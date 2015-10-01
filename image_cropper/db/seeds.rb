# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Role.create([{id: 1, name: 'admin'}, {id: 2, name: 'uploader'}, {id:3, name: 'cropper'}])
User.create([{name: 'Admin', email: 'ait.cropper@gmail.com', password: 'ta_280332', role_id: 1, is_active: true}])
User.create([{name: 'Uploader', email: 'tama_opps@hotmail.com', password: 'ta_280332', role_id: 2, is_active: true}])
User.create([{name: 'Cropper1', email: 'suwanna.x@gmail.com', password: 'ta_280332', role_id: 3, is_active: true}])
User.create([{name: 'Cropper2', email: 'tama.opps@gmail.com', password: 'ta_280332', role_id: 3, is_active: true}])

Tag.create([{name: "Cat"}])
