class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.belongs_to :grade, index: true, foreign_key: true
      t.belongs_to :reservation, index: true, foreign_key: true
      t.text :seat

      t.timestamps null: false
    end
  end
end
