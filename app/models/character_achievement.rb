class CharacterAchievement < ActiveRecord::Base
    belongs_to :character
    belongs_to :achievement
    
    def to_s
        return "#<CharacterAchievement #{ self.character ? self.character.name : "NOONE" } gained #{ self.achievement ? self.achievement.name : "NOTHING" } on #{ self.created_at.iso8601[0,10] }>"
    end
end
