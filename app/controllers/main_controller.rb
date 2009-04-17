class MainController < ApplicationController
    def guild_list
        @guilds = Guild.find(:all, :order => "name", :include => :realm ) # TODO, paginate or somehting
    end
    
    def nothing
        return render_404
    end
    
end
