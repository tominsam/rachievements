class AchievementToon < ActiveRecord::Base
    belongs_to :toon
    belongs_to :achievement
end
