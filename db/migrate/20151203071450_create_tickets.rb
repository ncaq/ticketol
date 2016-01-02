class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.belongs_to :grade, index: true, foreign_key: true, null: false
      t.belongs_to :reservation, index: true, foreign_key: true, null: false
      t.text :seat, null: false

      t.timestamps null: false
    end
  end
end
