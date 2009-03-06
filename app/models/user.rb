class User < ActiveRecord::Base
    has_many :guilds
end
