class GuildEmailAddress < ActiveRecord::Migration
  def self.up
      add_column :guilds, :email, :string, :limit => 100
      
      # testing
      #Guild.find_by_name("unassigned variable").update_attributes!( :email => "tom@jerakeen.org" )
  end

  def self.down
      remove_column :guilds, :email
  end
end
