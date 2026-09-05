module Games
  class LottoPlaysController < ApplicationController
    def create
      progress = Current.user.lotto_progress || LottoProgress.create_or_find_by!(user: Current.user)
      play, created = progress.play!(params[:chosen_number])

      respond_to do |format|
        format.html { redirect_to games_lotto_path, status: :see_other }
        format.json { render json: play_payload(play, progress, created), status: created ? :created : :ok }
      end
    rescue ArgumentError => error
      respond_to do |format|
        format.html { redirect_to games_lotto_path, alert: error.message, status: :see_other }
        format.json { render json: { error: error.message }, status: :unprocessable_entity }
      end
    end

    private
      def play_payload(play, progress, created)
        {
          play: {
            chosen_number: play.chosen_number,
            drawn_number: play.drawn_number,
            max_number: play.max_number,
            won: play.won,
            played_on: play.played_on
          },
          current_max_number: progress.reload.current_max_number,
          created: created
        }
      end
  end
end
