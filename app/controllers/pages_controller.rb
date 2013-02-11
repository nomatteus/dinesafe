class PagesController < ApplicationController
  layout "application_mobile", :except => :app_landing
  layout "landing", :only => :app_landing

  # Landing/promo page for app
  def app_landing
  end

  # About page for use in UIWebView in app
  def app_about
  end

  # About page for use in UIWebView in app
  def app_contact
  end

  # Privacy Policy page
  def app_privacy
  end
end
