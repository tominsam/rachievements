class MainController < ApplicationController
    def guild_list
        @guilds = Guild.order(:name).includes(:realm) # TODO, paginate or somehting
        respond_to do |format|
          format.html 
          format.js { render :layout => false }
        end
    end
    
    def nothing
        return render_404
    end
    
end
