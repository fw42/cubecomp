# https://github.com/rails/rails/pull/27429

require 'active_model/type/decimal'

module DecimalCastRescueRuby24
  def cast_value(value)
    if value.is_a?(::String)
      begin
        super(value)
      rescue ArgumentError
        0.0.to_d # preserve ruby 2.3.3 behaviour
      end
    else
      super(value)
    end
  end
end

ActiveModel::Type::Decimal.prepend DecimalCastRescueRuby24
