class CreateRealms < ActiveRecord::Migration
  def self.up
    create_table :realms do |t|
      t.string :name, :limit => 64, :null => false
      t.string :urltoken, :limit => 64, :null => false
      t.string :region, :limit => 2, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :realms
  end
end
