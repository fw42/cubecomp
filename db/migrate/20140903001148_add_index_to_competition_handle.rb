class AddIndexToCompetitionHandle < ActiveRecord::Migration
  def up
    add_index :competitions, :handle
  end

  def down
    remove_index :competitions, :handle
  end
end
