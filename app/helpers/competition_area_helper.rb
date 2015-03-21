module CompetitionAreaHelper
  def amount_with_currency(amount, currency)
    currency = currency.to_s.strip.downcase.capitalize

    currency = '€' if currency == 'Euro' || currency == 'Eur'
    currency = '$' if currency == 'Dollar'

    if currency == '€'
      "#{amount}#{currency}"
    else
      "#{currency}#{amount}"
    end
  end
end
