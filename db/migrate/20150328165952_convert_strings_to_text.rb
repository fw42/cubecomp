class ConvertStringsToText < ActiveRecord::Migration
  COLUMNS = {
    "competitions" => [ "venue_address" ],
    "competitors" => [ "free_entrance_reason", "paid_comment", "nametag" ],
    "news" => [ "text" ],
  }

  def up
    change_to(:text)
  end

  def down
    change_to(:string)
  end

  private

  def change_to(type)
    COLUMNS.each do |table, columns|
      columns.each do |column|
        change_column table.to_sym, column.to_sym, type
      end
    end
  end
end
