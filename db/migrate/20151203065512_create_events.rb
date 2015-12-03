class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.belongs_to :concert, index: true, foreign_key: true
      t.text :place
      t.datetime :date
      t.datetime :sell_start
      t.datetime :sell_end
      t.boolean :lottery

      t.timestamps null: false
    end
  end
end
