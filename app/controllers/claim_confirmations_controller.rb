class ClaimConfirmationsController < ApplicationController
  redispatch_request unless: :immutable?
end
