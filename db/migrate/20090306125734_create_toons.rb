class CreateToons < ActiveRecord::Migration
  def self.up
    create_table :toons do |t|
      t.string :name
      t.integer :realm_id
      t.integer :guild_id

      t.integer :rank
      t.integer :achpoints

      t.string :race, :limit => 16
      t.string :classname, :limit => 16
      t.string :gender, :limit => 16
      t.integer :level

      t.datetime :fetched_at
      t.timestamps
    end
  end

  def self.down
    drop_table :toons
  end
end
