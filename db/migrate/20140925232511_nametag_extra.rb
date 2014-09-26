class NametagExtra < ActiveRecord::Migration
  def change
    add_column :competitors, :nametag, :string
  end
end
