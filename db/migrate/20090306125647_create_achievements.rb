class CreateAchievements < ActiveRecord::Migration
  def self.up
    create_table :achievements do |t|
      t.string :name
      t.string :description
      t.integer :armory_id

      t.timestamps
    end
  end

  def self.down
    drop_table :achievements
  end
end
