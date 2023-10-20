# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# frozen_string_literal: true

ApplicationRecord.transaction do
    User.delete_all
    Privilege.delete_all
    
	# 権限設定
    Privilege.create(id: 1, p_name: 'emp') # employee
    Privilege.create(id: 2, p_name: 'lea') # leader
    Privilege.create(id: 3, p_name: 'adm') # administrator
    
	# 管理者ユーザ
	hashed_password = BCrypt::Password.create("shonsuke")
    User.create(id: 1, user_name: 'shonsuke', email: 'shonsuke@gmail.com', password_digest: hashed_password, privilege: 3)
end