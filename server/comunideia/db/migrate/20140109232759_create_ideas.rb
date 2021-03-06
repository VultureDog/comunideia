class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.string :name
      t.integer :status, default: 1
      t.integer :user_id
      t.datetime :date_start
      t.datetime :date_end
      t.string :summary
      t.string :local
      t.float :financial_value
      t.float :financial_value_sum_accumulated
      t.string :img_card
      t.string :video
      t.string :img_pg_1
      t.string :img_pg_2
      t.string :img_pg_3
      t.string :img_pg_4
      t.string :idea_content
      t.string :risks_challenges
      t.boolean :consulting_project, default: false
      t.boolean :consulting_creativity, default: false
      t.boolean :consulting_financial_structure, default: false
      t.string :consulting_specific

      t.timestamps
    end
    add_index :ideas, [:user_id, :created_at]
  end
end
