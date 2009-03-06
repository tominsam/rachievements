class Achievement < ActiveRecord::Base
    has_many :achievement_toons
    validates_uniqueness_of :armory_id
    validates_uniqueness_of :name

end
