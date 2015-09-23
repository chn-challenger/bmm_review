require 'data_mapper'
require './data_mapper_setup'

task :auto_upgrade do
  # auto_upgrade makes non-destructive changes.
  # if your tables don't exist, they will be created
  # but if they do and you changed your schema
  # (e.g. changed the type of one of the propertieis)
  # they will not be upgraded because that'd lead to data loss
  DataMapper.auto_upgrade!
  puts "Auto-upgrade completed!"
end

task :auto_migrate do
  # to force the creation of all tables as they are
  # discrubed in your moldes, even if this
  #may lead to data loss, use auto_migrate:
  DataMapper.auto_migrate!
  puts "Auto-migrate complete!"
end

# Finally don't forget that before you do any of that stuff,
# you need to create a database first
