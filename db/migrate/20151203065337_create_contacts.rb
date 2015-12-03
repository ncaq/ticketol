class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.text :subject
      t.text :request
      t.text :response

      t.timestamps null: false
    end
  end
end
