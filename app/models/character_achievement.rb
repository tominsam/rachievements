class CharacterAchievement < ActiveRecord::Base
    belongs_to :character
    belongs_to :achievement
end
