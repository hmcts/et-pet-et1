module Jadu
  class API
    # Usage: FilenameSanitizer.sanitize(string)
    #
    # Returns a string modified to fit the constraints of the Jadu API,
    # namely:
    #
    #
    #   1. To sanitize the filename remove any character not in one of the
    #      following unicode points.
    #
    #      \p{L}   any kind of letter from any language
    #      \p{N}   any kind of numeric character
    #      \p{M}   a character intended to be combined with another character
    #              (e.g. accents, umlauts, enclosing boxes etc...)
    #      \p{Cf}  invisible formatting indicator
    #      \p{Zs}  a whitespace character that is invisible, but does take up
    #              space
    #
    #   2. Remove any whitespace from the start and end of the file
    #
    #   3. Replace whitespace with underscores
    #
    class FilenameSanitizer
      def self.sanitize(s)
        new(s).sanitize
      end

      def initialize(str)
        @str = str
      end

      PIPELINE = %i[
        remove_leading_space
        remove_trailing_space
        replace_disallowed_characters_with_underscores
        replace_spaces_with_underscores
        remove_leading_junk
        remove_trailing_junk
      ].freeze

      def sanitize
        name, ext = extract_extension(@str)
        PIPELINE.inject(name) { |s, m| send(m, s) } + ext
      end

      private

      def extract_extension(str)
        match = str.match(/\A(.*?)(\.\p{Alnum}{3})\z/)
        if match
          [match[1], match[2]]
        else
          [str, '']
        end
      end

      def remove_leading_space(s)
        s.sub(/\A[\p{Space}\p{Cf}]+/, '')
      end

      def remove_trailing_space(s)
        s.sub(/[\p{Space}\p{Cf}]+\z/, '')
      end

      def replace_disallowed_characters_with_underscores(s)
        s.gsub(/[^\p{Alnum}\p{Mark}\p{Cf}\p{Space}]+/, '_')
      end

      def replace_spaces_with_underscores(s)
        s.gsub(/[\p{Space}\p{Cf}_]+/, '_')
      end

      def remove_leading_junk(s)
        s.sub(/\A\p{^Alnum}+/, '')
      end

      def remove_trailing_junk(s)
        s.sub(/\p{^Alnum}+\z/, '')
      end
    end
  end
end
