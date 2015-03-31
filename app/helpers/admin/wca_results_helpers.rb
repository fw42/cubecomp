module Admin::WcaResultsHelpers
  def format_time(time)
    "%.2f" % time.fdiv(100)
  end
end
