module Games
  class LottosController < ApplicationController
    def show
      @progress = Current.user.lotto_progress || Current.user.build_lotto_progress
      @play = Current.user.lotto_plays.find_by(played_on: Date.current)
    end
  end
end
