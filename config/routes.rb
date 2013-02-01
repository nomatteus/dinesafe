# For more info on routes: http://guides.rubyonrails.org/routing.html
Dinesafe::Application.routes.draw do
  match "/app"            => "pages#app_landing"
  match "/app/privacy"    => "pages#app_privacy"
  match "/app/about"      => "pages#app_about"


  get "inspections/index"
  get "inspections/map"
  get "establishment/search"

  # Routes for API. Versioning it 1.0 to possibly help with future changes.
  scope "/api/1.0" do
    resources :establishments, :inspections, :only => [:index, :show]
  end

  # Homepage
  root :to => "pages#app_landing"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
