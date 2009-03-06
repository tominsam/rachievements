class CreateRealms < ActiveRecord::Migration
  def self.up
    create_table :realms do |t|
      t.string :name, :limit => 64
      t.string :region
      t.timestamps
    end
  end

  def self.down
    drop_table :realms
  end
end
