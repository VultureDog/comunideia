class CreateInvestments < ActiveRecord::Migration
  def change
    create_table :investments do |t|
      t.integer :recompense_id
      t.integer :user_id
      t.float :financial_value

      t.timestamps
    end
    add_index :investments, [:recompense_id, :created_at]
    add_index :investments, [:user_id, :created_at]
  end
end
