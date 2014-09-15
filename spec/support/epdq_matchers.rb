module EpdqMatchers
  extend RSpec::Matchers::DSL

  EPDQ_FORM_PARAMS = {
     "SHASIGN" => "FB209D9B87130CC6DAE525ADEA03F43091DABAF8B698922F76A1ACE2D4556C6B",
    "CURRENCY" => "GBP",
    "LANGUAGE" => "en_US",
   "ACCEPTURL" => "http://www.example.com/apply/pay/success",
  "DECLINEURL" => "http://www.example.com/apply/pay/decline",
"EXCEPTIONURL" => "http://www.example.com/apply/pay/exception",
   "CANCELURL" => "http://www.example.com/apply/pay/cancel",
      "AMOUNT" => "25000",
     "ORDERID" => "fgr",
       "PSPID" => "ministry2"
  }.freeze

  matcher :have_epdq_form do
    match do |page|
      EPDQ_FORM_PARAMS.all? { |key, value| page.find("input##{key}").value == value }
    end

    failure_message do |page|
      EPDQ_FORM_PARAMS.select { |key, value| page.find("input##{key}").value != value }.
        map do |key, value|
          "Expected #{key} input to == #{page.find("input##{key}").value}, got #{value}"
      end.join "\n"
    end
  end
end
