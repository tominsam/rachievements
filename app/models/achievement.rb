class Achievement < ActiveRecord::Base
    has_many :character_achievements
    validates_uniqueness_of :armory_id
    validates_uniqueness_of :name

end
