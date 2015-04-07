module EntranceFeeValidation
  extend ActiveSupport::Concern

  included do
    validates :entrance_fee_competitors, presence: true
    validates :entrance_fee_competitors, numericality: {
      only_integer: false,
      greater_than_or_equal_to: 0
    }, allow_nil: true

    validates :entrance_fee_guests, presence: true
    validates :entrance_fee_guests, numericality: {
      only_integer: false,
      greater_than_or_equal_to: 0
    }, allow_nil: true
  end
end
