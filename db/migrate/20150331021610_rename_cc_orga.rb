class RenameCcOrga < ActiveRecord::Migration
  def change
    rename_column :competitions, :cc_orga, :cc_staff
  end
end
