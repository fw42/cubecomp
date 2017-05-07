class AddCompetitorsRemoteIp < ActiveRecord::Migration[5.1]
  def change
    add_column :competitors, :remote_ip, :string
    add_index :competitors, [ :remote_ip, :competition_id ]
  end
end
