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
            xml = open(self.armory_url, "User-agent" => 'Mozilla/5.0 (Windows; U; Windows NT 5.0; en-GB; rv:1.8.1.4) Gecko/20070515 Firefox/2.0.0.4') do |f|
                Hpricot.XML(f)
            end
        rescue Exception => e
            puts "** Error fetching #{ self }: #{ e }"
            return false
        end
        
        if rebuild # dangerous!
            self.character_achievements.destroy_all
        end

        (xml/"achievement").each do |achievement|
            self.add_achievement_from_xml( achievement )
        end
        
        if do_backfill
            self.backfill(data)
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
                xml = open(self.armory_url, "User-agent" => 'Mozilla/5.0 (Windows; U; Windows NT 5.0; en-GB; rv:1.8.1.4) Gecko/20070515 Firefox/2.0.0.4') do |f|
                    Hpricot.XML(f)
                end
            rescue Exception => e
                puts "** Error fetching #{ self }: #{ e }"
                return false
            end
        end
        
        categories = xml.search("rootCategories/category")
        for category in categories
            puts "fetching category #{ category['id'] }: #{ category["name"] }"
            begin
                category_xml = open(self.armory_url + "&c=#{ category["id"] }", "User-agent" => 'Mozilla/5.0 (Windows; U; Windows NT 5.0; en-GB; rv:1.8.1.4) Gecko/20070515 Firefox/2.0.0.4') do |f|
                    Hpricot.XML(f)
                end
            rescue Exception => e
                puts "** Error fetching #{ self } category #{ category["name"] }: #{ e }"
                return false
            end
            category_xml.search("//achievement").each do |achievement|
                # add completed achievements
                if achievement['dateCompleted']
                    self.add_achievement_from_xml( achievement )
                end
            end
        end

        # sometimes I get race conditions. This annoys me.
        self.clean_bad_data
        
        return true
    end
    
    def add_achievement_from_xml( achievement )

        ach = Achievement.find_by_armory_id( achievement['id'] )
        if ach.nil?
            ach = Achievement.new( :armory_id => achievement['id'] )
            ach.name = achievement['title']
            ach.description = achievement['desc']
            ach.icon_filename = achievement['icon']
            ach.save!
        end

        cach = self.character_achievements.find_by_achievement_id( ach.id )
        if cach.nil?
            # I'd like to do better on these timestamps. But the armoury is just
            # _way_ too unreliable for that to work. Date-level is as good as it gets.
            date_completed = achievement['dateCompleted']
            created_at = Time.parse(date_completed[0,10] + "T00:00:00+00:00").to_time
            cach = self.character_achievements.create!( :achievement_id => ach.id, :created_at => created_at )
        end
    end
    
    # don't know how this happens.
    def clean_bad_data
        self.character_achievements.group_by{|ca| ca.achievement.armory_id }.each{|aid, cas|
            if cas.size > 1
                cas[1,1000].each{|c| c.destroy }
            end
        }
    end
    
end
