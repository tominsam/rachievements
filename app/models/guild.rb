class Guild < ActiveRecord::Base
    belongs_to :realm
    has_many :characters, :order => "rank"
    has_many :character_achievements, :through => :characters, :order => "created_at desc"
    
    validates_uniqueness_of :name, :scope => :realm_id
    
    def to_s
        return "#<Guild #{self.name} / #{self.realm.name} / #{self.realm.region.upcase}>"
    end
    
    def before_save
        self.urltoken ||= self.name.downcase.gsub(/ /,'-')
    end
    
    def armory_url
        return "http://#{self.realm.hostname}/guild-info.xml?r=#{ CGI.escape( self.realm.name ) }&n=#{ CGI.escape( self.name ) }&p=1"
    end
    
    def refresh_from_armory
        puts "-- refreshing #{self}"
        require 'hpricot'
        require 'open-uri'

        # I like hpricot, ok?
        begin
            xml = open(self.armory_url, "User-agent" => 'Mozilla/5.0 (Windows; U; Windows NT 5.0; en-GB; rv:1.8.1.4) Gecko/20070515 Firefox/2.0.0.4') do |f|
                Hpricot(f)
            end
        rescue Exception => e
            puts "** Error fetching: #{ e }"
            return
        end

        (xml/"character").each do |character|
            char = self.realm.characters.find_by_name( character['name'] ) || self.realm.characters.new( :name => character[:name] )

            [ :race, :class, :gender, :level, :rank, :achpoints ].each do |p|
                char[(p == :class) ? :classname : p] = character[p.to_s]
            end
            char.guild = self
            char.save!
        end
        self.fetched_at = Time.now
        self.save!
    end
end
