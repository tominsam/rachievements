class CreateAchievementToons < ActiveRecord::Migration
  def self.up
    create_table :achievement_toons do |t|
      t.integer :toon_id, :null => false
      t.integer :achievement_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :achievement_toons
  end
end
