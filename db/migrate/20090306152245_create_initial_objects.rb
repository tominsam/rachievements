class CreateInitialObjects < ActiveRecord::Migration
  def self.up
      nordrassil = Realm.create!( :region => "eu", :name => "Nordrassil" )
      ua = nordrassil.guilds.create!( :name => "Unassigned Variable" )
  end

  def self.down
      Realm.destroy_all
      Guild.destroy_all
  end
end
