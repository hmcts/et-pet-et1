module EpdqMatchers
  extend RSpec::Matchers::DSL

  EPDQ_FORM_PARAMS = {
    "SHASIGN"    => "033E80017433C95505B2A52D2D654FEF2ACDCF5E7D5AEFFA8004B9A4489C9BF7",
    "CURRENCY"   => "GBP",
    "LANGUAGE"   => "en_US",
    "ACCEPTURL"  => "http://www.example.com/apply/pay/success",
    "DECLINEURL" => "http://www.example.com/apply/pay/decline",
    "AMOUNT"     => "25000",
    "ORDERID"    => "511234567800",
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
          "Expected #{key} input to == #{value}, got #{page.find("input##{key}").value}"
        }.
        join "\n"
    end
  end
end
