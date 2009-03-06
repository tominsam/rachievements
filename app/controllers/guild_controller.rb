class GuildController < ApplicationController
    before_filter :realm_from_params
    before_filter :guild_from_params
    
    def feed
        # TODO - there's probably a useful helper for this stuff.
        @title = "Achievements for #{ @guild.name }"
        @guid = "rachievments:#{ @realm.region }:#{ @realm.urltoken }:guild:#{ @guild.urltoken }"
        @items = @guild.character_achievements.all( :limit => 20, :order => "created_at desc" )
        render :template => "shared/feed", :layout => false
    end
    
    protected
    def guild_from_params
        @guild = @realm.guilds.find_by_urltoken( params[:name], :include => [ :characters ] )
        if @guild.nil?
            return render_404
        end
        @title = "Achievements for #{ @guild.name }"
        return true
    end
    
end
