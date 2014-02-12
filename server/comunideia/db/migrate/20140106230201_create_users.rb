class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.string :password_digest
      t.string :remember_token

      t.integer :cpf
      t.integer :birth_date
      t.string :address
      t.integer :address_num
      t.string :complement
      t.string :district
      t.integer :cep
      t.string :city
      t.string :region
      t.integer :phone
      t.integer :cell_phone
      t.boolean :notifications
      t.boolean :admin, default: false
      t.boolean :facebook_association, default: false

      t.timestamps
    end
    add_index :users, [:remember_token, :created_at]
    add_index :users, [:email, :created_at], unique: true
  end
end
