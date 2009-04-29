class CharacterController < ApplicationController
    before_filter :realm_from_params
    before_filter :character_from_params

    def show
        if params[:all]
            @items = @character.character_achievements.all( :order => "character_achievements.created_at desc" )
            return
        end

        # get a numberof days of achievements, rather than a number-limited list.
        time = Time.now
        while @items.nil? or @items.size < 3
            time -= 10.days
            @items = @character.character_achievements.all( :conditions =>  [ 'character_achievements.created_at >= ?', time ], :order => "character_achievements.created_at desc" )
            if time < Time.now - 2.months
                break
            end
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
