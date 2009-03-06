class GuildController < ApplicationController
    def index
        @guild = Guild.find_by_continent_and_server_and_name( params[:continent], params[:server], params[:name] )
        if @guild.nil?
            return render_404
        end

    end
end
