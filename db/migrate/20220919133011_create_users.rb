class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false   
      t.string :surname, null: false   
      t.string :othername, null: false   
      t.string :password_digest, null: false   
      t.boolean :is_verified, default: false, null: false   
      t.string :otp, null: true  

      t.timestamps
    end
  end
end
