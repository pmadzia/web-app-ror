class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :full_name,        null: false
      t.string :email,            null: false
      t.string :password_digest,  null: false
      t.string :job_position
      t.datetime :last_seen
      t.integer :status,          null: false, default: 0

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :last_seen
  end
end
