# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever

set :output, "log/cron.log"

# Check for new XML and update all data
every 1.day, at: '3:00 am' do
  rake "dinesafe:update_data"
end

# Refresh XML sitemap
every 1.day, at: '5:00 am' do
  rake "-s sitemap:refresh"
end
