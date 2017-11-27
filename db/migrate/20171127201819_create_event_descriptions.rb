class CreateEventDescriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :event_descriptions do |t|
      t.references :event, null: false, foreign_key: true
      t.string :language, null: false
      t.string :content, null: false
    end
    add_index :event_descriptions, [:event_id, :language], unique: true
  end
end
