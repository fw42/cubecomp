class CreateCompetitors < ActiveRecord::Migration
  def change
    create_table :competitors do |t|
      t.references :competition

      t.string :first_name
      t.string :last_name
      t.string :wca
      t.string :email
      t.date :birthday
      t.references :country
      t.boolean :local
      t.boolean :staff

      t.text :user_comment
      t.text :admin_comment

      t.boolean :free_entrance
      t.string :free_entrance_reason

      t.string :state
      t.boolean :confirmation_email_sent

      t.boolean :paid
      t.string :paid_comment

      t.timestamps
    end
  end
end
