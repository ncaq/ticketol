# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

case Rails.env
when "development"
  begin
    admin = User.create! do |u|
      u.email = 'admin@example.com'
      u.name = 'admin'
      u.password = ENV['ticketol_admin_password']
      u.password_confirmation = u.password
      u.admin!
    end
    admin.save!
  rescue
    p 'May be you forgot'
    p 'export ticketol_admin_password=hogehoge'
  end

  begin
    buyer = User.create! do |u|
      u.email = 'buyer@example.com'
      u.name = 'buyer'
      u.password = 'hogehoge'
      u.password_confirmation = u.password
      u.buyer!
    end
    buyer.save!
  rescue
  end

  begin
    seller = User.create! do |u|
      u.email = 'seller@example.com'
      u.name = 'seller'
      u.password = 'hogehoge'
      u.password_confirmation = u.password
      u.seller!
    end
    seller.save!
  rescue
  end
end
