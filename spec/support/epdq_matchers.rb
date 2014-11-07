module EpdqMatchers
  extend RSpec::Matchers::DSL

  EPDQ_FORM_PARAMS = {
    "SHASIGN"    => "3DF12D65A5772BB836E91EC4DAC2ACACF723B510CEAB9AF7A01B31D2B75071F6",
    "CURRENCY"   => "GBP",
    "LANGUAGE"   => "en_US",
    "ACCEPTURL"  => "http://www.example.com/apply/pay/success",
    "DECLINEURL" => "http://www.example.com/apply/pay/decline",
    "AMOUNT"     => "25000",
    "ORDERID"    => "fgr",
    "PSPID"      => "ministry2"
  }.freeze

  matcher :have_epdq_form do
    match do |page|
      EPDQ_FORM_PARAMS.all? { |key, value| page.find("input##{key}").value == value }
    end

    failure_message do |page|
      EPDQ_FORM_PARAMS.
        select { |key, value| page.find("input##{key}").value != value }.
        map { |key, value|
          "Expected #{key} input to == #{page.find("input##{key}").value}, got #{value}"
        }.
        join "\n"
    end
  end
end
