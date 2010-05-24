class CharacterAchievementIndex < ActiveRecord::Migration
  def self.up
    add_index :character_achievements, [ :achievement_id ]
    add_index :character_achievements, [ :character_id ]
  end

  def self.down
    remove_index :character_achievements, [ :achievement_id ]
    remove_index :character_achievements, [ :character_id ]
  end
end
