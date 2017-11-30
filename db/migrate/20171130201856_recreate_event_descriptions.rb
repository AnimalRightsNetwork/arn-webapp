class RecreateEventDescriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :event_descriptions, force: true do |t|
      t.references :event, foreign_key: true, index: false, null: false
      t.string :language, null: false
      t.string :content, null: false
    end
    add_index :event_descriptions, [:event_id, :language], unique: true
  end
end
