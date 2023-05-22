module Dinesafe
  def self.env
    defined?(Rails) ? Rails.env : ENV['RACK_ENV']
  end
end

Dinesafe::HOST     = ENV["DINESAFE_HOST"] || "dinesafe.to"
Dinesafe::SITE_URL = "https://#{Dinesafe::HOST}"
