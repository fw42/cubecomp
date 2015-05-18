class WcaTime
  attr_reader :value, :event

  def initialize(rank)
    @event = rank.eventId
    @value = rank.best
    @class = rank.class
  end

  def to_s
    return unless value

    case event
    when '333fm'
      fm
    when '333mbf'
      mbf
    else
      regular_time
    end
  end

  def fm
    if @class == Wca::RanksAverage
      "%.2f" % (value / 100.0)
    else
      value.to_s
    end
  end

  def mbf
    #  new: 0DDTTTTTMM
    #
    #  difference    = 99 - DD
    #  timeInSeconds = TTTTT (99999 means unknown)
    #  missed        = MM
    #  solved        = difference + missed
    #  attempted     = solved + missed

    difference = 99 - value.to_s[0..1].to_i
    time = value.to_s[2..6].to_i
    missed = value.to_s[7..8].to_i
    solved = difference + missed
    attempted = solved + missed

    minutes = (time / 60).to_i
    seconds = (time % 60)

    if minutes > 0
      time = "#{minutes}:" + sprintf("%02d", seconds)
    end

    "#{solved}/#{attempted} in #{time}"
  end

  def regular_time
    minutes = (value / 6000).to_i
    seconds = (value % 6000).to_f / 100.0

    if minutes > 0
      return "#{minutes}:" + ("%05.2f" % seconds)
    end

    "%.2f" % seconds
  end
end
