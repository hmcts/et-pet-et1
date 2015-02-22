module EpdqMatchers
  extend RSpec::Matchers::DSL

  EPDQ_FORM_PARAMS = {
    "SHASIGN"    => "F6B07A6814BF463E623E80AC486CEB046FC1272B8A3A9CC3B24233FC372060CD",
    "CURRENCY"   => "GBP",
    "LANGUAGE"   => "en_US",
    "ACCEPTURL"  => "http://www.example.com/apply/pay/success",
    "DECLINEURL" => "http://www.example.com/apply/pay/decline",
    "AMOUNT"     => "25000",
    "ORDERID"    => "511234567800",
    "PSPID"      => "ministry2",
    "TP"         => "http://www.example.com/apply/barclaycard-payment-template"
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
