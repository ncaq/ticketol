class CreateConcertImages < ActiveRecord::Migration
  def change
    create_table :concert_images do |t|
      t.belongs_to :concert, index: true, foreign_key: true
      t.binary :data, limit: 100.megabyte

      t.timestamps null: false
    end
  end
end
