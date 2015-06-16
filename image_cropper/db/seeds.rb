# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Role.create([{id: 1, name: 'admin'}, {id: 2, name: 'uploader'}, {id:3, name: 'cropper'}])
User.create([{name: 'Suwanna Xanthavanij', email: 'tama_opps@hotmail.com', password: 'ta_280332', role_id: 1, is_active: true}])
