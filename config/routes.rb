ActionController::Routing::Routes.draw do |map|

  #map.connect "/user/:username/:action", :controller => "user", :action => "index"
  #map.connect "/register", :controller => "user", :action => "register"

  map.connect "/", :controller => "main", :action => "guild_list"

  map.connect '/:region/:realm/:controller/:name/', :action => "show"
  map.connect '/:region/:realm/:controller/:name/achievement/:id', :action => "achievement"
  map.connect '/:region/:realm/:controller/:name/:action'

  # map.resources :realms do |realm|
  #   realm.resources :guilds, :member => {:feed => :get, :members => :get}
  # end

  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
