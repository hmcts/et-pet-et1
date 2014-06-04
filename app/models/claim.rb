class Claim < ActiveRecord::Base
  # has_many :claimants
  # has_many :respondents
  #
  # accepts_nested_attributes_for :claimants, :respondents

  attr_accessor :has_representative, :was_employed

  TRANSITIONS = [
    { from: :personal, to: :representative, if: :has_representative? },
    { from: :personal, to: :employer },
    { from: :representative, to: :employer },
    { from: :employer, to: :employment, if: :was_employed? },
    { from: :employer, to: :claim },
    { from: :employment, to: :claim }
  ].freeze

  def state
    (stack.last || :personal).to_sym
  end

  def next
    stack.push next_state
    stack_will_change!
  end

  def previous
    stack.pop
    stack_will_change!
  end

  def has_representative?
    !!has_representative
  end

  def was_employed?
    !!was_employed
  end

  private def next_state
    transitions = TRANSITIONS.select { |t| t[:from] == state }

    transition = transitions.detect do |t|
      if t[:if]
        send(t[:if]) ? t : next
      else
        t
      end
    end

    transition[:to]
  end
end
