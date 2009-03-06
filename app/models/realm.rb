class Realm < ActiveRecord::Base
    has_many :guilds, :order => "name"
    has_many :characters, :order => "name"

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
