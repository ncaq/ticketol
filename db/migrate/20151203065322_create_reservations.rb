class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.belongs_to :user, index: true, foreign_key: true, null: false
      t.belongs_to :grade, index: true, foreign_key: true, null: false
      t.integer :volume, null: false
      t.integer :buy_state, null: false, default: 0
      t.integer :payment_method, null: false
      t.text :convenience_password, null: false

      t.timestamps null: false
    end
    add_index :reservations, :convenience_password, unique: true
  end
end
