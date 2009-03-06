class CreateCharacterAchievements < ActiveRecord::Migration
  def self.up
    create_table :character_achievements do |t|
      t.integer :character_id, :null => false
      t.integer :achievement_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :character_achievements
  end
end
