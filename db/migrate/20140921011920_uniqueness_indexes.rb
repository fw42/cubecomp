class UniquenessIndexes < ActiveRecord::Migration
  def change
    old_indexes = {
      competitions: ['index_competitions_on_handle'],
      users: ['index_users_on_email']
    }

    new_indexes = {
      competitions: [ [:name], [:handle] ],
      competitors: [ [:wca, :competition_id ] ],
      countries: [ [:name] ],
      days: [ [:date, :competition_id] ],
      day_registrations: [ [:competitor_id, :day_id] ],
      events: [ [:handle, :competition_id] ],
      event_registrations: [ [:competitor_id, :event_id] ],
      locales: [ [:handle, :competition_id] ],
      permissions: [ [:user_id, :competition_id] ],
      themes: [ [:name] ],
      theme_files: [ [:filename, :competition_id] ],
      theme_file_templates: [ [:filename, :theme_id] ],
      users: [ [:email] ],
    }

    old_indexes.each do |table_name, index_names|
      index_names.each do |index_name|
        remove_index table_name, name: index_name
      end
    end

    new_indexes.each do |table_name, indexes|
      indexes.each do |column_names|
        add_index table_name, column_names, unique: true
      end
    end
  end
end
