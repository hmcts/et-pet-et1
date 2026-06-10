module Et1
  module Test
    module EmailObjects
      class Base < ::SitePrism::Page
        def initialize(mail)
          self.mail = mail
        end

        def load(expansion_or_html = {})
          # SitePrism deprecated loading HTML fragments in v5 and will remove in v6
          # If param is a string (HTML fragment), use Capybara.string instead
          if expansion_or_html.is_a?(String)
            @html_fragment = expansion_or_html
            visit '/fake-url'
            self
          else
            super
            self
          end
        end

        def to_capybara_node
          page
        end

        def page
          @page ||= Capybara::Session.new(:rack_test, mock_app)
        end

        private

        attr_accessor :mail, :html_fragment

        def mock_app
          @mock_app ||= proc {
            [200, { 'Content-Type' => 'text/html' }, html_fragment]
          }
        end
      end
    end
  end
end
