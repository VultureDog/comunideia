class CreateRecompenses < ActiveRecord::Migration
  def change
    create_table :recompenses do |t|
      t.string :title
      t.integer :idea_id
      t.float :quantity
      t.float :financial_value
      t.string :summary
      #t.datetime :date_delivery

      t.timestamps
    end
    add_index :recompenses, [:idea_id, :created_at]
  end
end
