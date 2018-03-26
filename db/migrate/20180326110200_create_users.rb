class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :account, null: false
      t.string :password_digest, null: false
      t.string :phone
      t.string :email
      t.string :username
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
