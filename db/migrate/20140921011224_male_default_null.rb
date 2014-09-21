class MaleDefaultNull < ActiveRecord::Migration
  def change
    change_column_null :competitors, :male, true
  end
end
