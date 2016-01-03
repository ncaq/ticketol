class CreateConcerts < ActiveRecord::Migration
  def change
    create_table :concerts do |t|
      t.text :title, null: false
      t.text :artist, null: false
      t.belongs_to :user, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
