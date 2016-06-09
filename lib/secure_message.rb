require 'base64'
require 'jose'

# Utility class to encrypt and decrypt message from this application
# - used for tokens: cookies, email
# - requires: ENV['MSG_KEY']

class SecureMessage
    def self.sign(message_object)
        app_secret_key = JOSE::JWK.from_okp(
            [:Ed25519, Base64.decode64(ENV['APP_SECRET_KEY'])]
        )
        app_secret_key.sign(message_object.to_json).compact
    end

    def self.msg_key
        Base64.strict_decode64(ENV['MSG_KEY'])
    end

    def self.encrypt(message)
        str = message.to_json
        jwk = JOSE::JWK.from_oct(msg_key)
        jwk.block_encrypt(str, 'alg' => 'dir', 'enc' => 'A256GCM').compact.to_s
    end

    def self.decrypt(secret_message)
        jwk = JOSE::JWK.from_oct(msg_key)
        plain = jwk.block_decrypt(secret_message).first
        JSON.load(plain)
    rescue
        raise 'INVALID ENCRYPTED MESSAGE'
    end
end
