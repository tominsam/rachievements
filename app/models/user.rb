class User < ActiveRecord::Base
    has_many :guilds
    
    def urltoken
        return self.username
    end
end
