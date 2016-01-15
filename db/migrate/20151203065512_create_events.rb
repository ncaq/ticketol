class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.belongs_to :concert,     index: true, foreign_key: true, null: false
      t.text       :place,       null:  false
      t.datetime   :date,        null:  false
      t.datetime   :sell_start,  null:  false
      t.datetime   :sell_end,    null:  false
      t.boolean    :lottery,     null:  false

      t.timestamps null: false
    end
    add_index :events, [:concert_id, :place, :date], unique: true
  end
end
