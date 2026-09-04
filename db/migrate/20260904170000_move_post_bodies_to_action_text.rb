require "erb"

class MovePostBodiesToActionText < ActiveRecord::Migration[8.1]
  class MigrationPost < ActiveRecord::Base
    self.table_name = "posts"
  end

  class MigrationRichText < ActiveRecord::Base
    self.table_name = "action_text_rich_texts"
  end

  def up
    MigrationPost.reset_column_information

    MigrationPost.where.not(body: [ nil, "" ]).find_each do |post|
      MigrationRichText.create!(
        record_type: "Post",
        record_id: post.id,
        name: "body",
        body: rich_text_html(post.body),
        created_at: post.created_at,
        updated_at: post.updated_at
      )
    end

    remove_column :posts, :body, :text
  end

  def down
    add_column :posts, :body, :text
    MigrationPost.reset_column_information

    MigrationRichText.where(record_type: "Post", name: "body").find_each do |rich_text|
      post = MigrationPost.find_by(id: rich_text.record_id)
      post&.update_column(:body, ActionText::Content.new(rich_text.body).to_plain_text)
    end

    MigrationRichText.where(record_type: "Post", name: "body").delete_all
  end

  private
    def rich_text_html(text)
      escaped = ERB::Util.html_escape(text.to_s).gsub(/\r\n?/, "\n")

      escaped.split(/\n{2,}/).map do |paragraph|
        "<p>#{paragraph.gsub("\n", "<br>")}</p>"
      end.join("\n\n")
    end
end
