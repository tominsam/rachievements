class GuildController < ApplicationController
    before_filter :realm_from_params
    before_filter :guild_from_params
    
    def toon
        @toon = @guild.toons.find_by_urltoken( params[:toon] )
    end
    
    protected

    def realm_from_params
        @realm = Realm.find_by_region_and_urltoken( params[:region], params[:realm] )
        if @realm.nil?
            return render_404
        end
        return true
    end

    def guild_from_params
        @guild = @realm.guilds.find_by_urltoken( params[:guild] )
        if @guild.nil?
            return render_404
        end
        return true
    end
end
