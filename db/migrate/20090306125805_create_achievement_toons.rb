class CreateAchievementToons < ActiveRecord::Migration
  def self.up
    create_table :achievement_toons do |t|
      t.integer :toon_id
      t.integer :achievement_id
      t.datetime :recorded_at

      t.timestamps
    end
  end

  def self.down
    drop_table :achievement_toons
  end
end
