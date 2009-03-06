class UserController < ApplicationController
    before_filter :get_user, :except => [ :register ]

    def index
        
    end
    
    def register
        @user = User.new( params[:user] )
        if request.post?
            if @user.save
                redirect_to user_url( @user )
            end
        end
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
