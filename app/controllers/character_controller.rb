class CharacterController < ApplicationController
    before_filter :realm_from_params
    before_filter :character_from_params

    protected
    def character_from_params
        @character = @realm.characters.find_by_urltoken( params[:name], :include => { :character_achievements => [ :achievement ], :guild => [] } )
        if @character.nil?
            return render_404
        end
        return true
    end

end
