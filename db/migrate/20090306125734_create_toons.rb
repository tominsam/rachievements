class CreateToons < ActiveRecord::Migration
  def self.up
    create_table :toons do |t|
      t.string :name, :null => false
      t.integer :realm_id, :null => false
      t.integer :guild_id

      t.integer :rank, :null => false
      t.integer :achpoints, :null => false

      t.string :race, :limit => 16, :null => false
      t.string :classname, :limit => 16, :null => false
      t.string :gender, :limit => 16, :null => false
      t.integer :level, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :toons
  end
end
