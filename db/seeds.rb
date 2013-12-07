# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ben = User.create(username: 'ben', password: 'ben', password_confirmation: 'ben')
neb = User.create(username: 'neb', password: 'neb', password_confirmation: 'neb')
table = Table.create(fiends: [ben, neb])
table.initial_bag = 'hellomynameisben'
table.save

(1..10).each do |i|
  ben.request_flip!(i)
  neb.request_flip!(i)
end
