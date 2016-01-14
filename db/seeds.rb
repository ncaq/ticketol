# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def create_user(name, role)
  User.create! { |u|
    u.email = name + '@example.com'
    u.name = name
    u.password = 'hogehoge'
    u.password_confirmation = u.password
    u.role = role
    yield u if block_given?
  }
end

def set_seat(event)
  seat = 100
  size = 10
  [['s', '10000'], ['a', '5000'], ['b', '2000']].each{ | (name, price) |
    grade = Grade.new
    grade.name = name
    grade.price = price
    event.grades << grade
    grade.save!
    tickets = (seat..seat + size).map{ |i|
      ticket = Ticket.new
      ticket.seat = i.to_s
      ticket
    }
    grade.tickets = tickets
    tickets.each(&:save!)
    seat += size
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

  create_user('buyer', 'buyer')
  create_user('buyer1', 'buyer')
  create_user('buyer2', 'buyer')
  create_user('buyer3', 'buyer')

  create_user('seller', 'seller')
  create_user('seller1', 'seller')
  create_user('seller2', 'seller')
  create_user('seller3', 'seller')

  create_user('suspend', 'admin') { |u|
    u.suspend = true
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
    event.date       = 20.day.from_now
    event.sell_start = Time.zone.now
    event.sell_end   = 10.day.from_now
    event.lottery = false
    concert.events << event
    event.save!
    set_seat(event)
  end

  begin
    event = Event.new
    event.place = 'lottery_event'
    event.date       = 20.day.from_now
    event.sell_start = Time.zone.now
    event.sell_end   = 10.day.from_now
    event.lottery = true
    concert.events << event
    event.save!
    set_seat(event)
  end

  begin
    event = Event.new
    event.place = 'soon_lottery_event'
    event.date       = 10.minute.from_now
    event.sell_start = Time.zone.now
    event.sell_end   = 10.second.from_now
    event.lottery = true
    concert.events << event
    event.save!
    set_seat(event)

    User.buyer.each { |u|
      res = Reservation.new { |r|
        r.user = u
        r.convenience!
      }
      res.lottery(event.grades.first, 1 + Random.rand(3))
    }
  end
end
