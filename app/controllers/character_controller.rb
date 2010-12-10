class CharacterController < ApplicationController
    before_filter :realm_from_params
    before_filter :character_from_params

    def show
        @page = params[:page].to_i
        if @page == 0
            @page = 1
        end
        # do it this way to get the guild first messages
        if @character.guild
            list = @character.guild.guild_achievements.where( :character_id => @character )
        else
            list = @character.character_achievements
        end
        @items = list.paginate(@page, 30).includes(:character)
        @total = list.count
        @items.length # have to call this. don't understand why.

        respond_to do |format|
          format.html 
          format.js { render :layout => false }
        end
    end

    def feed
        # TODO - there's probably a useful helper for this stuff.
        @title = "Achievements for #{ @character.name }"
        @guid = "tag:achievements.heroku.com,2009-03-06:/#{ @realm.region }/#{ @realm.urltoken }/character/#{ @character.urltoken }"
        @items = @character.character_achievements.all( :limit => 20, :order => "character_achievements.created_at desc" )
        render :template => "shared/feed", :layout => false
    end

    protected
    def character_from_params
        @character = @realm.characters.find_by_urltoken( params[:name], :include => { :character_achievements => [ :achievement ], :guild => [] } )
        if @character.nil?
            return render_404
        end
        @title = "Achievements for #{ @character.name }"
        return true
    end

end
