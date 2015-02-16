require 'jwt'

module BeOI

  module Auth

    def auth_subject!(token)
      raise UnauthorizedError, 'Empty authorization header' if token.nil? 
      begin
        decoded_token = JWT.decode(token, JWT.base64url_decode(BeOI::jwt_client_secret()))
      rescue JWT::DecodeError
        raise UnauthorizedError, 'Unable to decode token'
      end
      raise UnauthorizedError, 'Invalid jwt client id' if BeOI::jwt_client_id() != decoded_token["aud"]
      return decoded_token["sub"]
    end

  end
end
