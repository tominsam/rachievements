class GuildController < ApplicationController
    before_filter :realm_from_params
    before_filter :guild_from_params
    
    def show
        # get a number of days of achievements, rather than a number-limited list.
        @items = @guild.character_achievements.all( :conditions =>  [ 'character_achievements.created_at >= ?', Time.now - 10.days ], :order => "created_at desc" )
    end

    def feed
        # TODO - there's probably a useful helper for this stuff.
        @title = "Achievements for #{ @guild.name }"
        @guid = "tag:achievements.heroku.com,2009-03-06:/#{ @realm.region }/#{ @realm.urltoken }/guild/#{ @guild.urltoken }"
        @items = @guild.character_achievements.all( :limit => 20, :order => "created_at desc" )
        render :template => "shared/feed", :layout => false
    end
    
    def summary
        @items = @guild.character_achievements.all( :conditions => [ 'character_achievements.created_at >= ?', Date.today - 1.week ] )
        @people = @items.group_by{|i| i.character }.sort_by{|character, items| [ character.achpoints * -1, character.rank ] }
        @level_80 = @guild.characters.count(:conditions => { :level => 80 } )
        @total = @guild.characters.count
        @levels = @items.select{|i| i.achievement.name.match(/^Level \d+/) }.map{|i| [ i.character, i.achievement.name.downcase ] }.sort_by{|char, level| level }.reverse.uniq_by{|character, level| character }
        render :layout => false
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

