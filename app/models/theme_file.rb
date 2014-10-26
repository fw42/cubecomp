class ThemeFile < ActiveRecord::Base
  belongs_to :theme
  belongs_to :competition
  validate :validate_belongs_to_either_theme_or_competition

  has_attached_file :image

  validates :filename, presence: true
  validates :filename,
    uniqueness: { scope: :competition_id },
    allow_nil: true,
    allow_blank: true,
    unless: ->{ competition_id.nil? }
  validates :filename,
    uniqueness: { scope: :theme_id },
    allow_nil: true,
    allow_blank: true,
    unless: ->{ theme_id.nil? }

  validate :validate_template_errors
  validate :validate_has_content_or_is_image

  validates :image, attachment_content_type: {
    content_type: [ 'image/jpeg', 'image/gif', 'image/png' ],
    message: "has to be jpeg, gif, or png"
  }

  validates :image, attachment_file_name: {
    matches: [/\.(jpeg|jpg|gif|png)\Z/i],
    message: "has to end in .jpeg, .jpg, .gif, or .png"
  }

  validates :image, attachment_size: {
    less_than: 1.megabytes, message: "has to be smaller than 1 megabyte"
  }

  scope :with_filename, lambda { |name, locale, extension|
    filenames = [
      "#{name}.#{locale}.#{extension}",
      "#{name}.#{extension}",
    ]

    order_query_segments = filenames.map do |file|
      "filename = \"#{ThemeFile.connection.quote_string(file)}\" DESC"
    end

    where(filename: filenames).order(order_query_segments.join(', '))
  }

  scope :text_files, ->{ where(image_content_type: nil) }
  scope :image_files, ->{ where.not(image_content_type: nil) }

  def image_file_name
    if image?
      filename
    else
      nil
    end
  end

  def image_file_name=(filename)
    self.filename = filename
  end

  def type
    image? ? image_content_type : "text"
  end

  def size
    image? ? image_file_size : content.size
  end

  def image?
    image_content_type.present?
  end

  private

  def validate_template_errors
    Liquid::Template.parse(content)
  rescue Liquid::SyntaxError => e
    errors.add(:content, "Contains invalid Liquid code: #{e.message}")
  end

  def validate_has_content_or_is_image
    if content.present? && image?
      errors.add(:content, "has to be blank for image files")
    elsif content.blank? && !image?
      errors.add(:content, "can't be blank for text files")
    end
  end

  def validate_belongs_to_either_theme_or_competition
    if competition && theme
      errors.add(:base, "can't belong to both a competition and a theme")
    elsif !competition && !theme
      errors.add(:base, "needs to belong to either a theme or a competition")
    end
  end
end
