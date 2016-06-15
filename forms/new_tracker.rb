require 'dry-validation'

NewTracker = Dry::Validation.Form do
    key(:label).required
end
