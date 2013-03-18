# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Client.create :name => 'Golden Gate Disc Golf', :short_name => 'ggds'
Client.create :name => 'de Young', :short_name => 'dy'

admin_user = AdminUser.find_by_email 'admin@example.com'
admin_user.super_admin = true
admin_user.save