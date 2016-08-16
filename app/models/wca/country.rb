class Wca::Country < ActiveRecord::Base
  establish_connection :wca
  self.table_name = "Countries"
end
