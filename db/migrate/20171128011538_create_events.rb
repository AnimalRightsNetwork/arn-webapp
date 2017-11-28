class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.references :org, type: :string, foreign_key: true
      t.references :type, null: false, foreign_key: { to_table: :event_types }
      t.string :name, null: false
      t.string :image_url
      t.decimal :lat
      t.decimal :lon
      t.datetime :start_time, null: false
      t.datetime :end_time
    end
    add_index :events, :name
    add_index :events, :lat
    add_index :events, :lon
    add_index :events, :start_time
  end
end
