class CreateCharacters < ActiveRecord::Migration
  def self.up
    create_table :characters do |t|
      t.string :name, :null => false, :limit => 64
      t.string :urltoken, :null => false, :limit => 64
      t.integer :realm_id, :null => false
      t.integer :guild_id

      t.integer :rank, :null => false
      t.integer :achpoints, :null => false

      t.string :race, :limit => 16, :null => false
      t.string :classname, :limit => 16, :null => false
      t.string :gender, :limit => 16, :null => false
      t.integer :level, :null => false

      t.datetime :fetched_at

      t.timestamps
    end
  end

  def self.down
    drop_table :characters
  end
end
