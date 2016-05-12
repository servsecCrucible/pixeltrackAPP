namespace :key do
  require 'rbnacl/libsodium'
  require 'base64'

  desc 'Create rbnacl key'
  task :generate do
    key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
    puts "KEY: #{Base64.strict_encode64 key}"
  end
end
