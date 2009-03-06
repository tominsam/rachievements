class MainController < ApplicationController
    
    def index
        redirect_to :controller => "user", :action => "register"
    end
end
