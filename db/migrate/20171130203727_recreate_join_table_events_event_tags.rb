class RecreateJoinTableEventsEventTags < ActiveRecord::Migration[5.1]
  def change
    create_join_table :event_tags, :events, column_options: { foreign_key: true }, force: true do |t|
      t.index [:event_id, :event_tag_id], unique: true
      t.index [:event_tag_id, :event_id], unique: true
    end
  end
end
