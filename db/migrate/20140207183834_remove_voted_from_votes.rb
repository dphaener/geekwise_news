class RemoveVotedFromVotes < ActiveRecord::Migration
  def change
    remove_column :votes, :voted, :string
  end
end
