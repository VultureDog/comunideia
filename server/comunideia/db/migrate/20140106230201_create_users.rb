class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.string :password_digest
      t.string :remember_token

      t.string :cpf
      t.date :birth_date
      t.string :address
      t.integer :address_num
      t.string :complement
      t.string :district
      t.integer :cep, :limit => 8
      t.string :city
      t.string :region
      t.string :country
      t.integer :phone, :limit => 8
      t.integer :cell_phone, :limit => 8
      t.boolean :notifications
      t.boolean :admin, default: false
      t.boolean :facebook_association, default: false
      t.boolean :google_plus_association, default: false

      t.timestamps
    end
    add_index :users, [:remember_token, :created_at]
    add_index :users, [:email, :created_at], unique: true
  end
end
