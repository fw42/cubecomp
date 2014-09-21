class DefaultFalse < ActiveRecord::Migration
  def change
    changes = {
      competitors: [ :local, :staff, :free_entrance, :confirmation_email_sent, :paid ],
      users: [ :delegate ]
    }

    changes.each do |table_name, column_names|
      column_names.each do |column_name|
        change_column_default(table_name, column_name, false)
      end
    end
  end
end
