class ApplicationController < ActionController::Base
    include ActionController::Cookies
    protect_from_forgery with: :exception
  
    def encode_token(uid, email, user_type)
      payload = {
        data: {
          uid: uid,
          email: email,
          user_type: user_type
        },
        exp: Time.now.to_i + (6 * 3600)
      }
      JWT.encode(payload, 'secret', 'HS256')
    end
  
    def decode_token
      auth_header = request.headers['Authorization']
      if auth_header
        token = auth_header.split(' ')[1]
        begin
          JWT.decode(token, 'secret', true, algorithm: 'HS256')
        rescue JWT::DecodeError
          nil
        end
      end
    end
  
    def authorised_user
      decoded_token = decode_token()
      if decoded_token
        @uid = decoded_token[0]['data']['uid'].to_i
        @user_type = decoded_token[0]['data']['user_type']
      end
    end
  
    def user
      case @user_type
      when 'admin'
        Admin.find(@uid)
      when 'charity'
        Charity.find(@uid)
      when 'donor'
        Donor.find(@uid)
      else
        nil
      end
    end
  
    def save_user(id, user_type)
      session[:uid] = id
      session[:user_type] = user_type
      session[:expiry] = Time.now.to_i + (6 * 3600)
    end
  
    def session_expired?
      session[:expiry] ||= Time.now
      time_diff = session[:expiry].to_i - Time.now.to_i
      unless time_diff > 0
        render json: { message: 'failed', data: { info: 'Your session has expired. Please login again to continue' } }, status: 401
      end
    end
  
    def remove_user
      session.delete(:uid)
      session.delete(:user_type)
      session[:expiry] = Time.now
    end
  
    def authorize
      render json: { message: 'Unauthorized access' }, status: :unauthorized unless authorised_user
    end
  end  
