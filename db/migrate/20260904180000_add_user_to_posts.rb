class AddUserToPosts < ActiveRecord::Migration[8.1]
  class MigrationPost < ActiveRecord::Base
    self.table_name = "posts"

    def self.polymorphic_name
      "Post"
    end

    has_rich_text :body
  end

  def up
    MigrationPost.find_each(&:destroy!)
    add_reference :posts, :user, null: false, foreign_key: true
  end

  def down
    remove_reference :posts, :user, foreign_key: true
  end
end
