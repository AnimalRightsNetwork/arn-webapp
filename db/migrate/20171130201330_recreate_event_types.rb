class RecreateEventTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :event_types, force: true do |t|
      t.string :name, null: false
      t.string :icon_url, null: false
    end
    add_index :event_types, :name, unique: true
  end
end
