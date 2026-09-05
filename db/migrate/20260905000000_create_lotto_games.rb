class CreateLottoGames < ActiveRecord::Migration[8.1]
  def change
    create_table :lotto_progresses do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.integer :current_max_number, null: false, default: 2

      t.timestamps
    end

    add_check_constraint :lotto_progresses,
      "current_max_number BETWEEN 2 AND 100",
      name: "lotto_progresses_current_max_number_range"

    create_table :lotto_plays do |t|
      t.references :user, null: false, foreign_key: true
      t.date :played_on, null: false
      t.integer :max_number, null: false
      t.integer :chosen_number, null: false
      t.integer :drawn_number, null: false
      t.boolean :won, null: false

      t.timestamps
    end

    add_index :lotto_plays, [ :user_id, :played_on ], unique: true
    add_check_constraint :lotto_plays,
      "max_number BETWEEN 2 AND 100",
      name: "lotto_plays_max_number_range"
    add_check_constraint :lotto_plays,
      "chosen_number BETWEEN 1 AND max_number",
      name: "lotto_plays_chosen_number_range"
    add_check_constraint :lotto_plays,
      "drawn_number BETWEEN 1 AND max_number",
      name: "lotto_plays_drawn_number_range"
  end
end
