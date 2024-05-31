class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.integer :parent_id, index: true
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end
    add_foreign_key :posts, :posts, column: :parent_id
  end
end
