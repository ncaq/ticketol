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
    if ENV['ticketol_admin_password']
      User.create! { |u|
        u.email = 'admin@example.com'
        u.name = 'admin'
        u.password = ENV['ticketol_admin_password']
        u.password_confirmation = u.password
        u.admin!
      }
    else
      p 'May be you forgot'
      p 'export ticketol_admin_password=hogehoge'
    end
  rescue => e
    p e
  end

  begin
    User.create! { |u|
      u.email = 'buyer@example.com'
      u.name = 'buyer'
      u.password = 'hogehoge'
      u.password_confirmation = u.password
      u.buyer!
    }
  rescue => e
    p e
  end

  begin
    User.create! { |u|
      u.email = 'seller@example.com'
      u.name = 'seller'
      u.password = 'hogehoge'
      u.password_confirmation = u.password
      u.seller!
    }
  rescue => e
    p e
  end

  begin
    concert = Concert.new
    concert.title = 'seed'
    concert.artist = 'foo bar'
    concert.user_id = User.where(name: 'seller').first.id
    concert.save!

    concert_image = ConcertImage.new
    concert.concert_image = concert_image

    event = Event.new
    event.place = 'hoge'
    event.date       = DateTime.parse('2016-02-10')
    event.sell_start = DateTime.parse('2016-02-01')
    event.sell_end   = DateTime.parse('2016-02-09')
    event.lottery = false
    concert.events = [event]
    event.save!

    grade = Grade.new
    grade.name = 's'
    grade.price = '10000'
    event.grades = [grade]
    grade.save!

    tickets = (100..150).map{ |i|
      ticket = Ticket.new
      ticket.seat = i.to_s
      ticket
    }
    grade.tickets = tickets
    tickets.each(&:save!)
  rescue => e
    p e
  end
end
