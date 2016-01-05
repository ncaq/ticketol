class CreateLotteryPendings < ActiveRecord::Migration
  def change
    create_table :lottery_pendings do |t|
      t.belongs_to :reservation, index: true, foreign_key: true
      t.belongs_to :grade, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
