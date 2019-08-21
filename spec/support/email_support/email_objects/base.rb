module Et1
  module Test
    module EmailObjects
      class Base
        def initialize(mail)
          self.mail = mail
        end

        private

        attr_accessor :mail
      end
    end
  end
end
