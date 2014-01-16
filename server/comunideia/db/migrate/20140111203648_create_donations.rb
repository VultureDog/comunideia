class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.integer :idea_id
      t.integer :user_id
      t.float :financial_value
      t.datetime :date

      t.timestamps
    end
    add_index :donations, [:idea_id, :created_at]
    add_index :donations, [:user_id, :created_at]
  end
end
