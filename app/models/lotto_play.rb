class LottoPlay < ApplicationRecord
  belongs_to :user

  validates :played_on, presence: true, uniqueness: { scope: :user_id }
  validates :max_number, numericality: { only_integer: true, in: LottoProgress::MIN_MAX_NUMBER..LottoProgress::MAX_MAX_NUMBER }
  validates :chosen_number, :drawn_number, numericality: { only_integer: true, greater_than: 0 }
  validates :won, inclusion: { in: [ true, false ] }
  validate :numbers_are_in_range
  validate :outcome_matches_numbers

  private
    def numbers_are_in_range
      return unless max_number.is_a?(Integer)

      errors.add(:chosen_number, "must be within the draw range") unless chosen_number.is_a?(Integer) && chosen_number <= max_number
      errors.add(:drawn_number, "must be within the draw range") unless drawn_number.is_a?(Integer) && drawn_number <= max_number
    end

    def outcome_matches_numbers
      return if chosen_number.blank? || drawn_number.blank? || won.nil?

      errors.add(:won, "must match the drawn number") unless won == (chosen_number == drawn_number)
    end
end
