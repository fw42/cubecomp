module Liquid
  module Filters
    module I18n
      def translate_date(date, format = nil)
        options = { locale: default_locale }
        options[:format] = format if format
        ::I18n.l(date, options)
      end

      def translate(input, force_locale = nil)
        options = {}

        options[:locale] = if force_locale
          force_locale
        else
          default_locale
        end

        ::I18n.t(input, options)
      end

      private

      def default_locale
        @context.registers[:locale].handle
      end
    end
  end
end
