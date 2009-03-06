class Realm < ActiveRecord::Base
    has_many :guilds
    has_many :toons    

    validates_uniqueness_of :name, :scope => :region

    def hostname
        return (self.region == 'eu') ? "eu.wowarmory.com" : "www.wowarmory.com"
    end
    
end
