class AchievementIcon < ActiveRecord::Migration
  def self.up
      add_column :achievements, :icon_filename, :string, :limit => 64
  end

  def self.down
      remove_column :achievements, :icon_filename
  end
end
