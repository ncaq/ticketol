class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.belongs_to :event, index: true, foreign_key: true
      t.text :name
      t.integer :price

      t.timestamps null: false
    end
  end
end
