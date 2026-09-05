class GamesController < ApplicationController
  def index
    @lotto_progress = Current.user.lotto_progress
    @lotto_play = Current.user.lotto_plays.find_by(played_on: Date.current)
  end
end
