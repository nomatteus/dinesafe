module Dinesafe
  def self.conf
    @conf ||= Konf.new(
      File.expand_path('../settings.yml', File.dirname(__FILE__)), env
    )
  end

  def self.env
    defined?(Rails) ? Rails.env : ENV['RACK_ENV']
  end
end

Dinesafe::HOST     = Dinesafe.conf.host
Dinesafe::SITE_URL = "http://#{Dinesafe.conf.host}"
