class CompetitionLegalContact < ActiveRecord::Migration
  def change
    add_column :competitions, :owner_user_id, :integer
    add_column :users, :address, :text
  end
end
