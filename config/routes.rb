ActionController::Routing::Routes.draw do |map|

  #map.connect "/user/:username/:action", :controller => "user", :action => "index"
  #map.connect "/register", :controller => "user", :action => "register"

  map.connect "/", :controller => "main", :action => "index"

  map.connect '/:region/:realm/character/:toon', :controller => "main", :action => "toon"
  map.connect '/:region/:realm/guild/:guild', :controller => "main", :action => "guild"

  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
