class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.belongs_to :event, index: true, foreign_key: true, null: false
      t.text :name, null: false
      t.integer :price, null: false

      t.timestamps null: false
    end
  end
end
