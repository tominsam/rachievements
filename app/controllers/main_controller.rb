class MainController < ApplicationController
    before_filter :realm_from_params, :except => [ :index ]

    def index
        render_404
    end
    
    def guild
        @guild = @realm.guilds.find_by_urltoken( params[:guild], :include => [ :toons ] )
        if @guild.nil?
            return render_404
        end
    end
    
    def toon
        @toon = @realm.toons.find_by_urltoken( params[:toon],
            :include => { :achievement_toons => [ :achievement ], :guild => [] } )
        if @toon.nil?
            return render_404
        end
    end
    
    protected

    def realm_from_params
        @realm = Realm.find_by_region_and_urltoken( params[:region], params[:realm] )
        if @realm.nil?
            return render_404
        end
        return true
    end

end
