# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def seat_set(event)
  seat = 100
  [['s', '10000'], ['a', '5000'], ['b', '2000']].each{ | (name, price) |
    grade = Grade.new
    grade.name = name
    grade.price = price
    event.grades << grade
    grade.save!

    tickets = (seat..seat + 50).map{ |i|
      ticket = Ticket.new
      ticket.seat = i.to_s
      ticket
    }
    grade.tickets = tickets
    tickets.each(&:save!)

    seat += 50
  }
end

case Rails.env
when "development"
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

  User.create! { |u|
    u.email = 'buyer@example.com'
    u.name = 'buyer'
    u.password = 'hogehoge'
    u.password_confirmation = u.password
    u.buyer!
  }

  User.create! { |u|
    u.email = 'seller@example.com'
    u.name = 'seller'
    u.password = 'hogehoge'
    u.password_confirmation = u.password
    u.seller!
  }

  concert = Concert.new
  concert.title = 'seed'
  concert.artist = 'foo bar'
  concert.user_id = User.where(name: 'seller').first.id
  concert.save!

  concert_image = ConcertImage.new
  concert.concert_image = concert_image

  begin
    event = Event.new
    event.place = 'non_lottery_event'
    event.date       = Time.zone.parse('2016-02-10')
    event.sell_start = Time.zone.parse('2016-01-01')
    event.sell_end   = Time.zone.parse('2016-02-09')
    event.lottery = false
    concert.events << event
    event.save!
    seat_set(event)
  end

  begin
    event = Event.new
    event.place = 'lottery_event'
    event.date       = Time.zone.parse('2016-02-10')
    event.sell_start = Time.zone.parse('2016-01-01')
    event.sell_end   = Time.zone.parse('2016-02-09')
    event.lottery = true
    concert.events << event
    event.save!
    seat_set(event)
  end
end
