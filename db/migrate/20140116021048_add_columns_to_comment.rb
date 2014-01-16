class AddColumnsToComment < ActiveRecord::Migration
  def change
    add_column :comments, :content, :text
    add_reference :comments, :user, index: true
    add_reference :comments, :post, index: true
  end
end
