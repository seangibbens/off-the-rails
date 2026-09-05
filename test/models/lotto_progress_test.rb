require "test_helper"

class LottoProgressTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @progress = LottoProgress.create!(user: @user)
  end

  test "a matching draw advances the range by one" do
    play, created = @progress.play!(1, random_number: ->(_max) { 0 })

    assert created
    assert play.won?
    assert_equal 1, play.drawn_number
    assert_equal 3, @progress.reload.current_max_number
  end

  test "a loss keeps the current range" do
    play, = @progress.play!(1, random_number: ->(_max) { 1 })

    assert_not play.won?
    assert_equal 2, @progress.reload.current_max_number
  end

  test "a repeated play on the same day returns the original result" do
    first_play, = @progress.play!(1)
    second_play, created = @progress.play!(2)

    assert_not created
    assert_equal first_play, second_play
    assert_equal 1, @user.lotto_plays.count
  end

  test "a new Eastern calendar day permits another play" do
    travel_to Time.utc(2026, 9, 6, 3, 59) do
      @progress.play!(1)
    end

    travel_to Time.utc(2026, 9, 6, 4, 0) do
      _play, created = @progress.play!(1)
      assert created
    end

    assert_equal [ Date.new(2026, 9, 5), Date.new(2026, 9, 6) ], @user.lotto_plays.order(:played_on).pluck(:played_on)
  end

  test "the range remains capped at one hundred" do
    @progress.update!(current_max_number: 100)

    play, = @progress.play!(100, random_number: ->(_max) { 99 })

    assert play.won?
    assert_equal 100, @progress.reload.current_max_number
  end

  test "rejects a choice outside the current range" do
    error = assert_raises(ArgumentError) { @progress.play!(3) }

    assert_equal "Choose a number between 1 and 2.", error.message
    assert_empty @user.lotto_plays
  end
end
