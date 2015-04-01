module Liquid
  module Filters
    module Url
      def image_tag(filename)
        url = image_url(filename)
        return unless url
        "<img src=\"#{url}\">"
      end

      def image_url(filename)
        loader = ThemeFileLoader.new(competition.theme_files.image_files)
        theme_file = loader.find_by(filename: filename, locale: locale.handle)
        return unless theme_file
        theme_file.image.url
      end

      def theme_file_url(theme_file_filename, options = {})
        theme_file_locale = options['locale'] || locale.handle
        theme_file_filename = theme_file_filename.to_s.gsub(/\.html\z/, '')

        params = {
          competition_handle: competition.handle,
          locale: theme_file_locale
        }

        if theme_file_filename != 'index'
          params[:theme_file] = theme_file_filename
        end

        Rails.application.routes.url_helpers.competition_area_path(params)
      end

      private

      def competition
        @context.registers[:competition]
      end

      def locale
        @context.registers[:locale]
      end
    end
  end
end
