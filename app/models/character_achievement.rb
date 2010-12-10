class CharacterAchievement < ActiveRecord::Base
    belongs_to :character
    belongs_to :achievement

    scope :paginate, lambda{ |page,per_page|
        limit(per_page).offset( ((page>0) ? (page-1) : 0)*per_page )
    }
    
    def to_s
        return "#<CharacterAchievement #{ self.character ? self.character.name : "NOONE" } gained #{ self.achievement ? self.achievement.name : "NOTHING" } on #{ self.created_at.iso8601[0,10] }>"
    end
end
