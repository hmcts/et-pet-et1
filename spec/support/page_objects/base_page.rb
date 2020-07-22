require_relative '../sections'
require_relative '../messaging'
module ET1
  module Test
    class BasePage < ::SitePrism::Page
      include EtTestHelpers::Page
      include ::ET1::Test::I18n
      include ::RSpec::Matchers

      def initialize
        yield self if block_given?
      end

      def load(*)
        super
        self
      end

      element :google_tag_manager_head_script, :xpath, XPath.generate {|x| x.css('head script')[x.string.n.contains("googletagmanager")]}, visible: false
      element :google_tag_manager_body_noscript, :xpath, XPath.generate {|x| x.css('body noscript')[x.child(:iframe)[x.attr(:src).contains('googletagmanager')]]}
      def has_google_tag_manager_sections_for?(account)
        google_tag_manager_head_script.native.inner_html.include?(account) &&
          google_tag_manager_body_noscript.native.inner_html.include?(account)
      end

      def has_no_google_tag_manager_sections?
        has_no_google_tag_manager_head_script? && has_no_google_tag_manager_body_noscript?
      end

      def translate_if_needed(sym_or_str)
        return sym_or_str if sym_or_str.nil? || !sym_or_str.is_a?(Symbol)

        t(sym_or_str.to_s)
      end
    end
  end
end
