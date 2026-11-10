module Liquid
  module Filters
    module String
      def to_html(text)
        ApplicationController.helpers.simple_format(text, {}, wrapper_tag: "span")
      end
    end
  end
end
