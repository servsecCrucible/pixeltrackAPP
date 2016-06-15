require 'dry-validation'

AddContributor = Dry::Validation.Form do
    key(:email).required
end
