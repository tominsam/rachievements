class Realm < ActiveRecord::Base
    has_many :guilds
    has_many :characters    

    validates_uniqueness_of :name, :scope => :region
    
    def before_save
        self.urltoken ||= self.name.downcase.gsub(/ /,'-')
    end

    def hostname
        return (self.region == 'eu') ? "eu.wowarmory.com" : "www.wowarmory.com"
    end
    
    def to_s
        return "#{self.name} / #{self.region.upcase}"
    end
    
end
