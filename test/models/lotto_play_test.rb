require "test_helper"

class LottoPlayTest < ActiveSupport::TestCase
  test "requires an outcome that matches the numbers" do
    play = users(:one).lotto_plays.build(
      played_on: Date.current,
      max_number: 2,
      chosen_number: 1,
      drawn_number: 2,
      won: true
    )

    assert_not play.valid?
    assert_includes play.errors[:won], "must match the drawn number"
  end

  test "only allows one play per user and day" do
    attributes = { played_on: Date.current, max_number: 2, chosen_number: 1, drawn_number: 2, won: false }
    users(:one).lotto_plays.create!(attributes)
    duplicate = users(:one).lotto_plays.build(attributes)

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:played_on], "has already been taken"
  end
end
