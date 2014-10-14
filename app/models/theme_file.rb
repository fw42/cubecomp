class ThemeFile < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

  has_attached_file :image

  validates :filename, presence: true
  validates :filename, uniqueness: { scope: :competition_id }, allow_nil: true, allow_blank: true

  validate :validate_template_errors

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

  validate :cant_have_both_content_and_image

  scope :for_filename, lambda { |name, locale, extension|
    filenames = [
      "#{name}.#{locale}.#{extension}",
      "#{name}.#{extension}",
    ]

    order_query_segments = filenames.map do |file|
      "filename = \"#{ThemeFile.connection.quote_string(file)}\" DESC"
    end

    where(filename: filenames).order(order_query_segments.join(', '))
  }

  scope :text_files, ->{ where(image_file_name: nil) }
  scope :image_files, ->{ where.not(image_file_name: nil) }

  def image_file_name=(filename)
    self.filename = filename
    write_attribute(:image_file_name, filename)
  end

  def type
    image? ? image_content_type : "text"
  end

  def size
    image? ? image_file_size : content.size
  end

  def image?
    image_file_name.present?
  end

  private

  def validate_template_errors
    Liquid::Template.parse(content)
  rescue Liquid::SyntaxError => e
    errors.add(:content, "Contains invalid Liquid code: #{e.message}")
  end

  def cant_have_both_content_and_image
    return if content.blank? || image_file_name.blank?
    errors.add(:content, "has to be blank for image files")
  end
end
