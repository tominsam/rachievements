class UserController < ApplicationController
    before_filter :get_user, :except => [ :register ]

    def index
        
    end
    
    def register
        
    end
    
    
    protected
    def get_user
        @user = User.find_by_username( params[:username] )
        puts "** user is #{ @user }"
        if @user.nil?
            return render_404
        end
        return true
    end
end
