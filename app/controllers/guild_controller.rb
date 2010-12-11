class GuildController < ApplicationController
    before_filter :realm_from_params
    before_filter :guild_from_params
    
    def show
        @page = params[:page].to_i
        if @page == 0
            @page = 1
        end
        @items = @guild.guild_achievements.paginate(@page, 30).includes(:character)
        @total = @guild.guild_achievements.count
        @items.length # have to call this. don't understand why.

        respond_to do |format|
            format.html 
            format.js { render :layout => false }
        end
    end
    
    def members
      respond_to do |format|
        format.html 
        format.js { render :layout => false }
      end
    end

    def feed
        # TODO - there's probably a useful helper for this stuff.
        @title = "Achievements for #{ @guild.name }"
        @guid = "tag:achievements.heroku.com,2009-03-06:/#{ @realm.region }/#{ @realm.urltoken }/guild/#{ @guild.urltoken }"
        @items = @guild.guild_achievements.limit(30).includes(:character)
        render :template => "shared/feed", :layout => false
    end
    
    def summary
        @items = @guild.guild_achievements.where( [ 'created_at >= ?', Date.today - 1.week ] )
        @people = @items.group_by{|i| i.character }.sort_by{|character, items| [ character.achpoints * -1, character.rank ] }
        @people.each{|person,items|
            # replace items in place
            items[0..items.length] = items.sort_by{|i| [ (i.first ? 0 : 1), i.achievement_id * -1 ] }
        }
        @level_80 = @guild.characters.count(:conditions => { :level => 80 } )
        @total = @guild.characters.count
        @levels = @items.select{|i| i.achievement.name.match(/^Level \d+/) }.map{|i| [ i.character, i.achievement.name.downcase ] }.sort_by{|char, level| level }.reverse.uniq_by{|character, level| character }
        render :layout => false, :template => "guild_mailer/weekly_summary.html.rhtml", :content_type => "text/html"
    end
    
    def achievement
        @achievement = Achievement.find_by_armory_id( params[:id] )
        if @achievement.nil?
            return render_404
        end
        # no limit on this one, let's see everything. There will be at most #guild members rows
        @items = @guild.guild_achievements.where( :achievement_id => @achievement.id ).includes(:character)
        respond_to do |format|
          format.html 
          format.js { render :layout => false }
        end
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

