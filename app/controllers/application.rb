# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
    helper :all # include all helpers, all the time

    layout "main"

    # See ActionController::RequestForgeryProtection for details
    # Uncomment the :secret if you're not using the cookie session store
    protect_from_forgery # :secret => '299a579a0d5c0a27f1777564a5f4e04e'

    # See ActionController::Base for details 
    # Uncomment this to filter the contents of submitted sensitive data parameters
    # from your application log (in this case, all fields with names like "password"). 
    # filter_parameter_logging :password

    protected

    def render_404
        render :file => "public/404.html", :status => 404
        return false
    end

    def user_url( user, extra = {} )
        return url_for({ :controller => "user", :action => "index", :username => user.username }.merge(extra))
    end

    helper_method :guild_url
    def guild_url( guild, extra = {} )
        return url_for({ :controller => "guild", :action => "index", :region => guild.realm.region, :realm => guild.realm.urltoken, :guild => guild.urltoken }.merge(extra))
    end
    
    helper_method :toon_url
    def toon_url( toon, extra = {} )
        return guild_url( toon.guild, :action => "toon", :toon => toon.urltoken )
    end

end
