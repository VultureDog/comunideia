class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

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

      t.timestamps
    end
  end
end
