RSpec.describe Jadu::API::FilenameSanitizer do
  SPACE = [
    0x0020, # SPACE
    0x00A0, # NO-BREAK SPACE
    0x1680, # OGHAM SPACE MARK
    0x180E, # MONGOLIAN VOWEL SEPARATOR
    0x2000, # EN QUAD
    0x2001, # EM QUAD
    0x2002, # EN SPACE
    0x2003, # EM SPACE
    0x2004, # THREE-PER-EM SPACE
    0x2005, # FOUR-PER-EM SPACE
    0x2006, # SIX-PER-EM SPACE
    0x2007, # FIGURE SPACE
    0x2008, # PUNCTUATION SPACE
    0x2009, # THIN SPACE
    0x200A, # HAIR SPACE
    0x200B, # ZERO WIDTH SPACE
    0x202F, # NARROW NO-BREAK SPACE
    0x205F, # MEDIUM MATHEMATICAL SPACE
    0x3000, # IDEOGRAPHIC SPACE
    0xFEFF  # ZERO WIDTH NO-BREAK SPACE
  ].pack('U*')

  def self.permit(desc, input)
    it desc do
      expect(described_class.sanitize(input)).to eql(input)
    end
  end

  def self.sanitize(desc, input, output)
    it desc do
      expect(described_class.sanitize(input)).to eql(output)
    end
  end

  permit 'Latin', 'Latin'
  permit 'Cyrillic', 'Кириллица'
  permit 'Greek', 'Ελληνική'
  permit 'accented letters', 'café'
  permit 'Chinese', '中文'
  permit 'Japanese', 'かな'
  permit 'numbers', '0123456789'
  permit 'periods', 'example.pdf'
  permit 'PDF files', 'example.pdf'
  permit 'CSV files', 'example.csv'
  permit 'RTF files', 'example.rtf'
  permit 'text files', 'example.txt'

  sanitize 'leading and trailing space', "#{SPACE}text#{SPACE}", 'text'
  sanitize 'internal space', "file#{SPACE}with#{SPACE}spaces.pdf", 'file_with_spaces.pdf'
  sanitize 'punctuation', 'test"+-@#text', 'test_text'
  sanitize 'additional periods', 'foo.bar.baz.pdf', 'foo_bar_baz.pdf'
  sanitize 'spaces and punctuation together', 'Wow! A filename!.pdf', 'Wow_A_filename.pdf'
end
