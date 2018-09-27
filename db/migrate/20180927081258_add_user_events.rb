class AddUserEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :user_events do |t|
      t.integer :user_id, null: false
      t.jsonb :data, null: false
      t.datetime :created_at, null: false
    end

    add_foreign_key :user_events, :users
  end
end
