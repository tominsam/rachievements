class CreateGuilds < ActiveRecord::Migration
  def self.up
    create_table :guilds do |t|
      t.string :name, :limit => 64
      t.string :urltoken, :limit => 64, :null => false
      t.integer :realm_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :guilds
  end
end
