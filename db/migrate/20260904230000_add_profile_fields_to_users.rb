class AddProfileFieldsToUsers < ActiveRecord::Migration[8.1]
  def up
    add_column :users, :username, :string
    add_column :users, :avatar_key, :string, default: "orbit", null: false

    migration_user = Class.new(ActiveRecord::Base) do
      self.table_name = "users"
    end
    used_usernames = {}

    migration_user.order(:id).each do |user|
      root = user.email_address.to_s.split("@", 2).first.to_s.parameterize(separator: "_").gsub(/[^a-z0-9_-]/, "").first(24)
      root = "member" if root.length < 3
      candidate = root
      suffix = 2

      while used_usernames.key?(candidate)
        suffix_text = "_#{suffix}"
        candidate = "#{root.first(30 - suffix_text.length)}#{suffix_text}"
        suffix += 1
      end

      user.update_columns(username: candidate)
      used_usernames[candidate] = true
    end

    change_column_null :users, :username, false
    add_index :users, :username, unique: true
  end

  def down
    remove_index :users, :username
    remove_columns :users, :username, :avatar_key
  end
end
