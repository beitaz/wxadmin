class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username, null: false, index: true
      t.string :password_digest, null: false
      t.string :phone
      t.string :email
      t.string :nick
      t.integer :role, default: 0, comment: '0: normal; 1: admin'
      t.datetime :last_login
      t.boolean :deleted, default: false
      t.timestamps
    end
    add_index :users, :phone, unique: true
    add_index :users, :email, unique: true
  end
end
