class RecreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events, force: true do |t|
      t.references :org, type: :string, foreign_key: true
      t.references :event_type, foreign_key: true, null: false
      t.string :name, null: false
      t.string :image_url
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :lon, precision: 10, scale: 6
      t.datetime :start_time, null: false
      t.datetime :end_time
      t.string :fb_url

      t.timestamps
    end
    add_index :events, :name
    add_index :events, :start_time
    add_index :events, [:lat, :lon]
  end
end
