class RemoveRankFromPost < ActiveRecord::Migration
  def change
    remove_column :posts, :rank, :string
  end
end
