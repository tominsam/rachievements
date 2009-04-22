# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

    def user_url( user, extra = {} )
        only_path = (controller.class != GuildMailer)
        return url_for({ :only_path => only_path, :controller => "user", :action => "index", :username => user.username }.merge(extra))
    end

    def guild_url( guild, extra = {} )
        only_path = (controller.class != GuildMailer)
        return url_for({ :only_path => only_path, :controller => "guild", :action => "index", :region => guild.realm.region, :realm => guild.realm.urltoken, :name => guild.urltoken }.merge(extra))
    end
    
    def character_url( character, extra = {} )
        only_path = (controller.class != GuildMailer)
        return url_for({ :only_path => only_path, :controller => "character", :action => "index", :region => character.realm.region, :realm => character.realm.urltoken, :name => character.urltoken }.merge(extra))
    end
    
    def achievement_url( ach, guild, extra = {} )
        only_path = (controller.class != GuildMailer)
        return url_for({ :only_path => only_path, :controller => "guild", :action => "achievement", :region => guild.realm.region, :realm => guild.realm.urltoken, :name => guild.urltoken, :id => ach.armory_id }.merge(extra))
    end

end
