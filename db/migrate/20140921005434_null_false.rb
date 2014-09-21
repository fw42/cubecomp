class NullFalse < ActiveRecord::Migration
  def change
    changes = {
      competitions: [ :name, :handle, :staff_email, :city_name, :country_id ],
      competitors: [ :competition_id, :first_name, :last_name, :email, :country_id ],
      countries: [ :name ],
      days: [ :competition_id, :date, :entrance_fee_competitors, :entrance_fee_guests ],
      day_registrations: [ :competition_id, :day_id, :competitor_id ],
      events: [ :competition_id, :day_id, :name_short, :name, :handle, :start_time, :state ],
      event_registrations: [ :competition_id, :event_id, :competitor_id ],
      locales: [ :competition_id, :handle ],
      news: [ :competition_id, :time, :text, :locale_id ],
      permissions: [ :competition_id, :user_id ],
      themes: [ :name ],
      theme_files: [ :competition_id, :filename ],
      theme_file_templates: [ :theme_id, :filename ],
      users: [ :email, :first_name, :last_name, :permission_level ]
    }

    changes.each do |table_name, column_names|
      column_names.each do |column_name|
        change_column_null table_name, column_name, false
      end
    end
  end
end
