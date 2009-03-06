class CreateAchievements < ActiveRecord::Migration
  def self.up
    create_table :achievements do |t|
      t.string :name, :null => false
      t.text :description, :null => false
      t.integer :armory_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :achievements
  end
end
