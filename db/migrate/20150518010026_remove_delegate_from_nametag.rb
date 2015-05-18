class RemoveDelegateFromNametag < ActiveRecord::Migration
  def change
    Competitor.where("LOWER(nametag) LIKE ?", "%delegate%").update_all(nametag: nil)
  end
end
