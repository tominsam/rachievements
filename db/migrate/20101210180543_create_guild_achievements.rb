class CreateGuildAchievements < ActiveRecord::Migration
  def self.up
    create_table :guild_achievements do |t|
      t.integer :guild_id, :null => false
      t.integer :character_id, :null => false
      t.integer :achievement_id, :null => false
      t.timestamps
    end
    add_index :guild_achievements, [ :guild_id ]
  end

  def self.down
    drop_table :guild_achievements
  end
end
