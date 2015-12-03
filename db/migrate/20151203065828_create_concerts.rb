class CreateConcerts < ActiveRecord::Migration
  def change
    create_table :concerts do |t|
      t.text :title
      t.text :artist
      t.binary :image
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
