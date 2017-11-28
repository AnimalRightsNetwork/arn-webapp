class AddTimestampsToEvent < ActiveRecord::Migration[5.1]
  def change
    add_timestamps :events, default: DateTime.now
  end
end
