class AddColumnToLikes < ActiveRecord::Migration
  def change
    add_column :likes, :likers_count, :integer, :default => 0
  end
end
