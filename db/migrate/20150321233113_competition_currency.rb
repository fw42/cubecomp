class CompetitionCurrency < ActiveRecord::Migration
  def change
    add_column :competitions, :currency, :string
  end
end
