class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.references :org, foreign_key: true
      t.references :type, null: false, foreign_key: true
      t.string :name, null: false
      t.string :image_url
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :lon, precision: 10, scale: 6
      t.datetime :start_time, null: false
      t.datetime :end_time

      t.timestamps
    end
    add_index :events, :name
    add_index :events, :lat
    add_index :events, :lon
    add_index :events, :start_time
    add_index :events, :end_time
  end
end
