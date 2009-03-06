class CreateToons < ActiveRecord::Migration
  def self.up
    create_table :toons do |t|
      t.string :name
      t.integer :guild_id

      t.timestamps
    end
  end

  def self.down
    drop_table :toons
  end
end
