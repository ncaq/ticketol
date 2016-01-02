class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.belongs_to :user, index: true, foreign_key: true, null: false
      t.text :subject, null: false
      t.text :request, null: false
      t.text :response

      t.timestamps null: false
    end
  end
end
