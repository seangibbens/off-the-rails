class LottoProgress < ApplicationRecord
  MIN_MAX_NUMBER = 2
  MAX_MAX_NUMBER = 100

  belongs_to :user

  validates :current_max_number,
    numericality: { only_integer: true, in: MIN_MAX_NUMBER..MAX_MAX_NUMBER }

  def play!(chosen_number, played_on: Date.current, random_number: SecureRandom.method(:random_number))
    choice = Integer(chosen_number, exception: false)

    with_lock do
      if (existing_play = user.lotto_plays.find_by(played_on: played_on))
        return [ existing_play, false ]
      end

      unless choice&.between?(1, current_max_number)
        raise ArgumentError, "Choose a number between 1 and #{current_max_number}."
      end

      result = random_number.call(current_max_number) + 1
      won = choice == result
      play = user.lotto_plays.create!(
        played_on: played_on,
        max_number: current_max_number,
        chosen_number: choice,
        drawn_number: result,
        won: won
      )

      increment!(:current_max_number) if won && current_max_number < MAX_MAX_NUMBER
      [ play, true ]
    end
  end
end
