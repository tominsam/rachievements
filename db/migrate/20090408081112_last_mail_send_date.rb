class LastMailSendDate < ActiveRecord::Migration
  def self.up
      add_column :guilds, :email_sent_at, :datetime
  end

  def self.down
      remove_column :guilds, :email_sent_at
  end
end
