class GuildController < ApplicationController
    before_filter :realm_from_params
    before_filter :guild_from_params
    
    
    
    protected
    def guild_from_params
        @guild = @realm.guilds.find_by_urltoken( params[:guild] )
        if @guild.nil?
            return render_404
        end
        return true
    end
end
