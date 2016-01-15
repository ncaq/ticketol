class CreateConcerts < ActiveRecord::Migration
  def change
    create_table :concerts do |t|
      t.belongs_to :user, index: true, foreign_key: true, null: false
      t.text :title, null: false
      t.text :artist, null: false
      t.binary :image, limit: 100.megabyte

      t.timestamps null: false
    end
  end
end
