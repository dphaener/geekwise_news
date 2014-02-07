class CreateCommentVotes < ActiveRecord::Migration
  def change
    create_table :comment_votes do |t|
      t.references :user, index: true
      t.references :comment, index: true

      t.timestamps
    end
  end
end
