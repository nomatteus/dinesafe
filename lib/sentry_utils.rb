require 'net/http'
require 'uri'
require 'json'

# Quick util to send cron heartbeats to Sentry. No Ruby SDK support yet, so send 
# requests manually following this guide: 
# https://docs.sentry.io/product/crons/getting-started/http/
class SentryUtils
  class << self
    # Returns id that should be passed to cron_end so that duration is tracked.
    def cron_start(monitor_slug)
      response = send_heartbeat(monitor_slug, "in_progress")
      response["id"]
    end

    def cron_end(monitor_slug, checkin_id)
      send_heartbeat(monitor_slug, "ok", checkin_id)
    end

    private

    def send_heartbeat(monitor_slug, status, checkin_id='')
      uri = URI.parse(sentry_cron_checkin_uri(monitor_slug, checkin_id))
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      # http.set_debug_output($stdout)

      headers = {
        "Content-Type": "application/json",
        "Authorization": "DSN #{ENV['SENTRY_DSN']}"
      }
      
      # Valid values for `status`:
      # - "in_progress" (job is running)
      # - "ok" (job completed successfully)
      # - "error" (job failed)
      data = {
        status: status,
        environment: Rails.env
      }

      request_class = checkin_id.present? ? Net::HTTP::Put : Net::HTTP::Post
      request = request_class.new(uri.request_uri, headers)
      request.body = data.to_json

      response = http.request(request)
      JSON.parse(response.body)
    end

    def sentry_cron_checkin_uri(monitor_slug, checkin_id='')
      raise "Missing Env Var: SENTRY_ORGANIZATION" unless ENV['SENTRY_ORGANIZATION'].present?

      checkin_url = checkin_id.present? ? "#{checkin_id}/" : ""
      "https://sentry.io/api/0/organizations/#{ENV['SENTRY_ORGANIZATION']}/monitors/#{monitor_slug}/checkins/#{checkin_url}"
    end
  end
end
