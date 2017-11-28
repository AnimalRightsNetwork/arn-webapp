class CreateEventTags < ActiveRecord::Migration[5.1]
  def change
    create_table :event_tags do |t|
      t.string :name, null: false
      t.string :icon_url, null: false
      t.string :color, null: false
    end
    add_index :event_tags, :name, unique: true
  end
end
