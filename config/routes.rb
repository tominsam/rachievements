ActionController::Routing::Routes.draw do |map|

  #map.connect "/user/:username/:action", :controller => "user", :action => "index"
  #map.connect "/register", :controller => "user", :action => "register"

  map.connect "/", :controller => "main", :action => "index"

  map.connect '/:region/:realm/:controller/:name/:action', :action => "index"

  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
