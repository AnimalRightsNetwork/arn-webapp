class AddFbUrlToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :fb_url, :string
  end
end
