class ReplaceEventTypeForeignKey < ActiveRecord::Migration[5.1]
  def up
    remove_reference :events, :type, index: true, foreign_key: true
    add_reference :events, :event_type, foreign_key: true
  end

  def down
    remove_reference :evnts, :event_type, index: true, foreign_key: true
    add_reference :events, :type, foreign_key: true
  end
end
