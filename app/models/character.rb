class Character < ActiveRecord::Base
    belongs_to :realm
    belongs_to :guild

    has_many :character_achievements, :order => "character_achievements.created_at desc, character_achievements.id", :include => [ :achievement ]

    validates_uniqueness_of :name, :scope => :realm_id
    
    def to_s
        return "#<Character #{ self.name } / #{ self.realm.name } / #{ self.realm.region.upcase }>"
    end
    
    def before_save
        self.urltoken ||= self.name.downcase.gsub(/ /,'-')
    end

    def armory_url
        return "http://#{self.realm.hostname}/character-achievements.xml?r=#{ CGI.escape( self.realm.name ) }&n=#{ CGI.escape( self.name ) }"
    end

    def refresh_from_armory( do_backfill = false )
        puts "-- refreshing #{self}"

        begin
            xml = Fetcher.fetch(self.armory_url)
        rescue Exception => e
            STDERR.puts "** Error fetching #{ self }: #{ e }"
            return false
        end
        
        character = (xml/"character")[0]
        
        self.achpoints = character["points"].to_i
        
        achievements = (xml/"achievement").map{|a| Achievement.from_xml(a) }
        need_to_add = achievements.select{|a| !self.has_achievement?(a) }

        if need_to_add.size >= 5
            puts "   5 achievements - need to backfill"
            if !self.backfill(xml)
                return false
            end

        elsif need_to_add.size > 0
            puts "   adding #{ need_to_add.size } achievements"
            (xml/"achievement").each do |achievement|
                if !self.add_achievement_from_xml( achievement )
                    return false
                end
            end

        else
            puts "   nothing to do"
        end

        self.fetched_at = Time.now.utc
        self.save!
        
        # sometimes I get race conditions. This annoys me.
        self.clean_bad_data
        
        return true
    end
    

    def backfill( xml = nil )
        # _everyone_ hit level 10.
        # Character.all.select{|c| c.character_achievements.size > 0 and !Achievement.find_by_armory_id(6).character_achievements.map(&:character_id).include?(c.id) }[0,3].each(&:backfill)
        puts "-- backfilling #{self}"

        if xml.nil?
            begin
                xml = Fetcher.fetch(self.armory_url)
            rescue Exception => e
                STDERR.puts "** Error fetching #{ self }: #{ e }"
                return false
            end
        end
        
        categories = xml.search("rootCategories/category")
        for category in categories
            puts "   fetching category #{ category['id'] }: #{ category["name"] }"
            begin
                category_xml = Fetcher.fetch(self.armory_url + "&c=#{ category["id"] }")
            rescue Exception => e
                STDERR.puts "** Error fetching #{ self } category #{ category["name"] }: #{ e }"
                return false
            end
            category_xml.search("//achievement").each do |achievement|
                # add completed achievements
                if achievement['dateCompleted']
                    if !self.add_achievement_from_xml( achievement )
                        return false
                    end
                end
            end
        end

        # sometimes I get race conditions. This annoys me.
        self.clean_bad_data
        
        return true
    end
    
    def add_achievement_from_xml( achievement )

        ach = Achievement.from_xml( achievement )

        cach = self.character_achievements.find_by_achievement_id( ach.id )

        if cach.nil?
            # I'd like to do better on these timestamps. But the armoury is just
            # _way_ too unreliable for that to work. Date-level is as good as it gets.
            date_completed = achievement['dateCompleted']
            created_at = Time.parse(date_completed[0,10] + "T00:00:00+00:00").to_time
            cach = self.character_achievements.create!( :achievement_id => ach.id, :created_at => created_at )
        end
        
        return true
    end
    
    def has_achievement?( ach )
        return !self.character_achievements.find_by_achievement_id( ach.id ).nil?
    end
    
    # don't know how this happens.
    def clean_bad_data
        self.character_achievements.select{|ca| ca.achievement }.group_by{|ca| ca.achievement.armory_id }.each{|aid, cas|
            if cas.size > 1
                cas[1,1000].each{|c| c.destroy }
            end
        }
    end
    
end
