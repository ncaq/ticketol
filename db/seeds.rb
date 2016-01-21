# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'find'

@app_files = Find.find('.').select{ |fp| fp.end_with?('.rb') }
@avoid_overlap = 0
def random_word()
  @avoid_overlap += 1
  File.read(@app_files.sample).scan(/\w+/).sample() + @avoid_overlap.to_s
end

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

case Rails.env
when 'development'
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
    p 'export ticketol_admin_password'
  end

  create_user('buyer',  'buyer')
  create_user('seller_pending', 'seller_pending')
  create_user('seller', 'seller')

  (0..10).each{ |n|
    create_user('buyer'          + n.to_s, 'buyer')
    create_user('seller_pending' + n.to_s, 'seller_pending')
    create_user('seller'         + n.to_s, 'seller')
    create_user('admin'          + n.to_s, 'admin')
    create_user('suspend_buyer'  + n.to_s, 'buyer') { |u|
      u.suspend = true
    }
  }

  rand(5..10).times {
    concert = Concert.create!{ |c|
      c.title  = random_word()
      c.artist = random_word()
      c.user   = User.seller.sample
    }

    rand(1..5).times {
      event = Event.create!{ |e|
        if rand(2) == 0
          e.place      = random_word()
          e.sell_start = rand(0..3).minute.from_now
          e.sell_end   = e.sell_start + rand(1..60).minute
          e.date       = e.sell_end + rand(1..2).minute
          e.lottery    = rand(0..1)
          e.concert    = concert
        else
          e.place      = random_word()
          e.sell_start = rand(10..100).minute.from_now
          e.sell_end   = e.sell_start + rand(10..1000).minute
          e.date       = e.sell_end + rand(1..60*5).minute
          e.lottery    = rand(0..1)
          e.concert    = concert
        end
      }

      rand(1..5).times {
        grade = Grade.create! { |g|
          g.name  = random_word()
          g.price = rand(1000..10000)
          g.event = event
        }
        seat_start = rand(0..100)
        seat_end = seat_start + rand(1..30)
        (seat_start..seat_end).map { |seat_name|
          Ticket.create! { |t|
            t.seat = grade.name.first + seat_name.to_s
            t.grade = grade
          }
        }
        rand(0..(seat_end - seat_start)).times {
          if event.lottery
            r = ReservationFormEnableLottery.new
            r.volume = rand(1..4)
          else
            r = ReservationFormDisableLottery.new
            r.tickets = grade.tickets.sample(rand(1..4))
          end
          r.user = User.buyer.sample
          r.grade = grade
          r.payment_method = Reservation.payment_methods.keys.sample
          begin
            r.record_save
          rescue => e
            puts e
          end
        }
      }
    }
  }

  [['rapid_sell_start', 3], ['slow_sell_start', 100]].each { |(title, delay)|
    concert = Concert.create!{ |c|
      c.title  = title
      c.artist = 'foo'
      c.user   = User.where(name: 'seller').first
    }

    [false, true].each{ |b|
      event = Event.create!{ |e|
        e.place      = random_word()
        e.sell_start = delay.minute.from_now
        e.sell_end   = e.sell_start + 60.minute
        e.date       = e.sell_end + 60.minute
        e.lottery    = b
        e.concert    = concert
      }
      10.times.each{ |gi|
        grade = Grade.create! { |g|
          g.name  = gi.to_s
          g.price = gi * 100
          g.event = event
        }
        seat_start = gi * 100
        seat_end   = seat_start + 100
        (seat_start..seat_end).map { |seat_name|
          Ticket.create! { |t|
            t.seat = grade.name.first + seat_name.to_s
            t.grade = grade
          }
        }
        rand(0..(seat_end - seat_start)).times {
          if event.lottery
            r = ReservationFormEnableLottery.new
            r.volume = rand(1..4)
          else
            r = ReservationFormDisableLottery.new
            r.tickets = grade.tickets.sample(rand(1..4))
          end
          r.user = User.buyer.sample
          r.grade = grade
          r.payment_method = Reservation.payment_methods.keys.sample
          begin
            r.record_save
          rescue => e
            puts e
          end
        }
      }
    }
  }
end
