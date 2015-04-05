class LegacyCompetitor < ActiveRecord::Base
  include LegacyModel
  serialize :days
end
