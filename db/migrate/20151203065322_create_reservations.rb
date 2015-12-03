class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.integer :payment_method

      t.timestamps null: false
    end
  end
end
