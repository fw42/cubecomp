class DefaultForceCustomDomainSslToFalse < ActiveRecord::Migration
  def up
    change_column :competitions, :custom_domain_force_ssl, :boolean, default: false
  end

  def down
    change_column :competitions, :custom_domain_force_ssl, :boolean
  end
end
