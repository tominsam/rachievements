class Achievement < ActiveRecord::Base
    has_many :character_achievements
    validates_uniqueness_of :armory_id
    #validates_uniqueness_of :name
    
    def wowhead_url
        "http://www.wowhead.com/?achievement=#{ self.armory_id }"
    end
    
    def icon_url
        "http://eu.wowarmory.com/wow-icons/_images/51x51/#{ self.icon_filename }.jpg"
    end


    def self.from_xml( achievement )

        ach = self.find_by_armory_id( achievement['id'] )
        if ach.nil?
            ach = Achievement.new( :armory_id => achievement['id'] )
            ach.name = achievement['title']
            ach.description = achievement['desc']
            ach.icon_filename = achievement['icon']
            ach.save!
        end
        
        return ach
    end


end
