After do |scenario|
  if scenario.failed?
    puts "scenario failed"
    puts "Output from netstat"
    puts `netstat -an`
  end
end
