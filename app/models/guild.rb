class Guild < ActiveRecord::Base
    has_one :user
    has_many :toons

    validates_uniqueness_of :name, :server, :continent
end
