class Toon < ActiveRecord::Base
    belongs_to :realm
    belongs_to :guild

    has_many :achievement_toons
    has_many :achievements, :through => :achievement_toons, :order => "recorded_at"

    validates_uniqueness_of :name, :scope => :realm_id
    
    
end
