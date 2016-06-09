namespace :key do
    namespace :symmetric do
        require 'rbnacl/libsodium'
        require 'base64'

        desc 'Create rbnacl key'
        task :generate do
            key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
            puts "KEY: #{Base64.strict_encode64 key}"
        end
    end

    namespace :asymmetric do
        require 'jose'

        desc 'Create Ed25519 octet keypair (512 bit secret key) for signing'
        task :generate do
            new_app_secret = JOSE::JWK.generate_key([:okp, :Ed25519])
            new_app_public = new_app_secret.to_public

            saved_secret_key = Base64.strict_encode64(new_app_secret.to_okp[1])
            saved_public_key = Base64.strict_encode64(new_app_public.to_okp[1])

            puts "SECRET KEY: #{saved_secret_key}"
            puts "PUBLIC KEY: #{saved_public_key}"
        end
    end
end
