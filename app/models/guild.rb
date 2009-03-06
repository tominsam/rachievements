require 'hpricot'
require 'open-uri'

class Guild < ActiveRecord::Base
    belongs_to :realm
    has_many :toons
    
    validates_uniqueness_of :name, :scope => :realm_id
    
    def before_save
        self.urltoken ||= self.name.downcase.gsub(/ /,'-')
    end
    
    def armory_url
        return "http://#{self.realm.hostname}/guild-info.xml?r=#{ CGI.escape( self.realm.name ) }&n=#{ CGI.escape( self.name ) }&p=1"
    end
    
    def refresh_from_armory
        # I like hpricot, ok?
        xml = open(self.armory_url, "User-agent" => 'Mozilla/5.0 (Windows; U; Windows NT 5.0; en-GB; rv:1.8.1.4) Gecko/20070515 Firefox/2.0.0.4') do |f|
            Hpricot(f)
        end

        (xml/"character").each do |character|
            puts character['name']
            toon = self.realm.toons.find_or_create_by_name( character['name'] )

            [ :race, :class, :gender, :level, :rank, :achpoints ].each do |p|
                toon[(p == :class) ? :classname : p] = character[p.to_s]
            end
            toon.guild = self
            
            toon.save!
        end
        self.toons.reload
    end
end
