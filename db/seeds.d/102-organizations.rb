# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# !!! PLEASE KEEP THIS SCRIPT IDEMPOTENT !!!
#

unless Rails.env.test?
  Organization.all.each do |org|
    User.as(::User.anonymous_api_admin.login) do
      ForemanTasks.sync_task(::Actions::Katello::Organization::Create, org) unless org.library
    end
  end
end

if ENV['SEED_ORGANIZATION']
  if Setting['db_pending_seed']
    admin = User.where(:login => ENV['SEED_ADMIN_USER'].present? ? ENV['SEED_ADMIN_USER'] : 'admin').first
    if admin && admin.default_organization.nil?
      admin.default_organization = Organization.find_by(:name => ENV['SEED_ORGANIZATION'])
      admin.save!
    end
  end
end
