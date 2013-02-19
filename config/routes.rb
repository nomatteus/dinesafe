# For more info on routes: http://guides.rubyonrails.org/routing.html
Dinesafe::Application.routes.draw do
  scope "/app" do
    match "/" => "pages#app_landing", :as => :app_landing
    match "/privacy"    => "pages#app_privacy"
    match "/about"      => "pages#app_about"
    match "/contact"    => "pages#app_contact"
    match "/press"      => "pages#app_press"
    match "/press_release" => "pages#app_press_release1"
    # URLs look like this: dinesafe.to/app/place/10344670/savoy-pub
    # "place" instead of "establishment" for brevity
    match "/place/:id/:slug"    => "establishments#show_app", :as => :establishment_landing
  end

  # match "/app"            => "pages#app_landing"
  # match "/app/privacy"    => "pages#app_privacy"
  # match "/app/about"      => "pages#app_about"
  # match "/app/contact"      => "pages#app_contact"


  get "inspections/index"
  get "inspections/map"
  get "establishment/search"

  # Routes for API. Versioning it 1.0 to possibly help with future changes.
  scope "/api/1.0" do
    resources :establishments, :inspections, :only => [:index, :show]
  end

  # Redirect homepage to app landing page, for now
  root :to => redirect("/app")

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
