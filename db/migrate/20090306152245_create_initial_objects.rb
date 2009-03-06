class CreateInitialObjects < ActiveRecord::Migration
  def self.up
      nordrassil = Realm.create!( :region => "eu", :name => "Nordrassil" )
      ua = nordrassil.guilds.create!( :name => "Unassigned Variable" )
      ua.refresh_from_armory
  end

  def self.down
      Realm.destroy_all
      Guild.destroy_all
  end
end
