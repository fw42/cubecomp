class LocaleDrop < Liquid::Drop
  def initialize(locale)
    @locale = locale
  end

  delegate :handle, :name, to: :@locale
end
