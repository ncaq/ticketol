class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.belongs_to :user, index: true, foreign_key: true, null: false
      t.integer :payment_method, null: false
      t.text :receive_password

      t.timestamps null: false
    end
  end
end
