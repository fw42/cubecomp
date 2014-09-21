class MaleDefaultNull2 < ActiveRecord::Migration
  def change
    change_column_default :competitors, :male, nil
  end
end
