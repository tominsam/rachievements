class Toon < ActiveRecord::Base
    has_one :guild
    has_many :achievement_toons
    has_many :achievements, :throught => :achievement_toons
end
