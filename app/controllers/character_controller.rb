class CharacterController < ApplicationController
    before_filter :realm_from_params
    before_filter :character_from_params

    def feed
        # TODO - there's probably a useful helper for this stuff.
        @title = "Achievements for #{ @character.name }"
        @guid = "tag:///rachievments/#{ @realm.region }/#{ @realm.urltoken }/character/#{ @character.urltoken }/"
        @items = @character.character_achievements.all( :limit => 10, :order => "created_at desc" )
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
