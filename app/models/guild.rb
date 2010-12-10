require 'fetcher'

class Guild < ActiveRecord::Base
    belongs_to :realm
    has_many :characters, :order => "rank"
    has_many :character_achievements, :through => :characters, :order => "character_achievements.created_at desc", :include => [ :achievement ] # TODO - because we're through characters here, we can't include characters?
    
    validates_uniqueness_of :name, :scope => :realm_id
    
    def to_s
        "#<Guild #{self.name} / #{self.realm.name} (#{self.realm.region.upcase})>"
    end
    
    def to_param
      self.urltoken
    end
    
    def before_save
      self.urltoken ||= self.name.downcase.gsub(/ /,'-')
    end
    
    def armory_url
        "http://#{self.realm.hostname}/guild-info.xml?r=#{ CGI.escape( self.realm.name ) }&n=#{ CGI.escape( self.name ) }&p=1&rhtml=no"
    end
    
    def refresh_from_armory
        puts "-- refreshing #{self}"

        # I like hpricot, ok?
        begin
            xml = Fetcher.fetch(self.armory_url)
        rescue Exception => e
            STDERR.puts "** Error fetching: #{ e }\n  #{e.backtrace.join("\n  ")}"
            return
        end
        
        (xml/"character").each do |character|
            char = self.realm.characters.find_by_name( character['name'] )
            if char.nil?
                char = self.realm.characters.new( :name => character[:name] )
            end

            [ :level, :rank ].each do |p|
                char[p] = character[p.to_s]
            end
            
            # TODO - Alliance races. Meh.
            char.race = {
                2 => "Orc",
                5 => "Undead",
                6 => "Tauren",
                8 => "Troll",
                10 => "Blood Elf",
            }[ character['raceId'].to_i ] || character['race'].to_s || 'Race'

            char.classname = {
                1 => "Warrior",
                2 => "Paladin",
                3 => "Hunter",
                4 => "Rogue",
                5 => "Priest",
                6 => "Death Knight",
                7 => "Shaman",
                8 => "Mage",
                9 => "Warlock",
                11 => "Druid",
            }[ character['classId'].to_i ] || character['class'].to_s || "Class"

            char.gender = character['genderId'] == '0' ? "male" : "female"
            
            char.achpoints ||= 0 # sensible default, the number in the guild XML response isn't reliable

            if char.guild != self
                char.guild = self
                # TODO - associate all achievements
            end

            char.save!
        end
        self.fetched_at = Time.now.utc
        self.save!
    end
    
    
    def oldest_fetch
        return characters.order("fetched_at").first.fetched_at
    end

end
