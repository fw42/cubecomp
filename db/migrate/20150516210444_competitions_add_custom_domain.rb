class CompetitionsAddCustomDomain < ActiveRecord::Migration
  def change
    add_column :competitions, :custom_domain, :string
    add_column :competitions, :custom_domain_force_ssl, :boolean
  end
end
