class CompetitionAddDelegateUserId < ActiveRecord::Migration
  def up
    add_column :competitions, :delegate_user_id, :integer
  end

  def down
    remove_column :competitions, :delegate_user_id
  end
end
