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


end
