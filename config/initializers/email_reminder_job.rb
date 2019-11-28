require 'rubygems'
require 'rake'
require 'rufus-scheduler'

load File.join(Rails.root, 'Rakefile')

ENV['days']='2'

scheduler = Rufus::Scheduler.new

scheduler.cron '30 09 * * MON' do
  task = Rake.application['redmine:send_reminders']
  task.reenable
  task.invoke
end
