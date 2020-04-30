module HasWcaId
  extend ActiveSupport::Concern

  included do
    if self == Competitor
      validates :wca,
        uniqueness: { scope: :competition_id, case_sensitive: true },
        allow_nil: true,
        allow_blank: true
    else
      validates :wca, uniqueness: { case_sensitive: true }, allow_nil: true, allow_blank: true
    end

    validates :wca, format: { with: /\A\d{4}\w+\d\d\Z/ }, allow_nil: true, allow_blank: true

    auto_strip_attributes :wca

    before_validation do
      self.wca = wca.upcase if wca
    end
  end
end
