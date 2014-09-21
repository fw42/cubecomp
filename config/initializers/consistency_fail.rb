if Rails.env.test?
  require 'consistency_fail/enforcer'
  ConsistencyFail::Enforcer.enforce!
end
