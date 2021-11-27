class AuthenticationTokenService
    HMAC_SECRET = 'my$ecretK3y'
    ALGORITH_TYPE = 'HS256'
    def self.call(user_id)
        payload = {user_id: user_id}

        JWT.encode payload, HMAC_SECRET, ALGORITH_TYPE
    end
end