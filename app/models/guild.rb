class Guild < ActiveRecord::Base
    has_one :user
    has_many :toons
end
