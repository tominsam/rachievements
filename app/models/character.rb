class Character < ActiveRecord::Base
    belongs_to :realm
    belongs_to :guild

    has_many :character_achievements, :order => "created_at desc", :include => [ :achievement ]

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

    def refresh_from_armory
        puts "-- refreshing #{self}"
        require 'hpricot'
        require 'open-uri'

        begin
            xml = open(self.armory_url, "User-agent" => 'Mozilla/5.0 (Windows; U; Windows NT 5.0; en-GB; rv:1.8.1.4) Gecko/20070515 Firefox/2.0.0.4') do |f|
                Hpricot(f)
            end
        rescue Exception => e
            puts "** Error fetching: #{ e }"
            return
        end

        (xml/"achievement").each do |achievement|
            ach = Achievement.find_by_armory_id( achievement['id'] )
            if ach.nil?
                ach = Achievement.new( :armory_id => achievement['id'] )
            end

            ach.name = achievement['title']
            ach.description = achievement['desc']
            ach.icon_filename = achievement['icon']
            # TODO - only if changed!
            ach.save!
            
            cach = self.character_achievements.find_by_achievement_id( ach.id )
            if cach.nil?
                cach = self.character_achievements.new( :achievement_id => ach.id )
                
                # there's no time-level resolution on this stuff. So
                # if it was completed today, assume it was completed at scan time,
                # otherwise back-date it to the day we saw it on.
                if achievement['datecompleted'][0,10] == Time.now.iso8601[0,10]
                    cach.created_at = Time.now
                else
                    cach.created_at = Date.parse(achievement['datecompleted'][0,10] + "T23:59:59").to_time
                end
                cach.save!
            end
        end
        self.fetched_at = Time.now
        self.save!
    end
    
end
