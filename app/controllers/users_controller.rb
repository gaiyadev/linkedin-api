class UsersController < ApplicationController
    skip_before_action :authorize_request, only: [:sign_up, :sign_in, :verify_email, :find_by_id,
         :forgot_password, :destory, :reset_password]


    def sign_up
        begin
            user = User.new()
            user.email = params[:email]
            user.surname = params[:surname]
            user.othername = params[:othername]
            user.password = params[:password]
            user.password_confirmation = params[:password_confirmation]
            user.otp = rand.to_s[2..7]
            if user.save() 
                # Send email 
                UserMailer.with(user: user).email_verification.deliver_later
                # response
                return render json: {
                status: "Success", 
                status_code: 201, 
                message: "Account created successfully.", 
                data: {
                    id: user.id,
                    email: user.email
                }, 
                }, 
                :status => :created 
            else
                render json: {
                    error:"Bad request",
                    message: user.errors.full_messages,
                    status_code: 400
                }, 
                :status => :bad_request 
            end
        rescue => exception
            render json: {
                message: exception, 
                status_code: 500,
                error: "Internal server error",
            }, 
            :status => :internal_server_error 
        end               
    end

# Verify email
    def verify_email
        begin
        user = User.find_by(otp: params[:otp])
        if !user
            render json: {
                error: "Not found",
                message: "Invalid otp",
                status_code: 404
            }, 
            :status => :not_found 
        else
        user.is_verified = true
        user.otp = nil
        if user.save(validate: false)
            return render json: {
                status: "Success", 
                status_code: 201, 
                message: "Account activated successfully.", 
                data: {
                    id: user.id,
                    is_verified: user.is_verified
                }, 
             }, 
            :status => :created 
        else
            render json: {
                error:"Unprocessable entity",
                message:  "Error while  saving",
                status_code: 422
            }, 
            :status => :unprocessable_entity 
        end
        end       
        rescue => exception
            render json: {
                message: exception,
                status_code: 500,
                error:"Internal server error",
            }, 
            :status => :internal_server_error 
        end
    end

    # Sign in
    def sign_in
        begin
       user = User.find_by(email: user_params[:email])
        if user.is_verified == false
           render json: {
                error: "Forbidden",
                message: "Account not verified",
            }, 
            status: :forbidden   
        else
            if user && user.authenticate(user_params[:password])
            access_token = JsonWebToken::encode(user_id: user.id, email: user.email)
            time = Time.now + 24.hours.to_i
            render json: {
                status: "Success",
                message: "Login successfully",
                status_code: 200, 
                data: {
                    email: user.email,
                    id: user.id
                }, 
                access_token: access_token,
                exp: time.strftime("%m-%d-%Y %H:%M"),
            }, 
            status: :ok    
        else
            render json: {
                message: "Invalid email and/or Password",
                status_code: 403, error: "forbidden"
            }, 
            status: :forbidden    
        end
        end
        rescue => exception
            render json: { 
                message: exception, 
                status_code: 500,
                error:"Internal server error",
            }, 
            status: :internal_server_error
        end   
    end
    
    # Find by id

    def find_by_id
       begin
        user = User.select("id, surname, othername, is_verified, email").find_by(id: params[:id])
        if !user
             render json: {
                error: "Not found",
                message: "User not found",
            }, 
            :status => :not_found    
        else
            render json: {
            status: "Success",
            status_code: 200, 
            message: "Fetched successfully",
            data: user,
            }, 
            :status => :ok    
        end
           
        rescue => exception
            render json: {
                message: exception, 
                status_code: 500
            },
            :status => :internal_server_error    
        end
    end

    # Delete user
    def destroy
        begin
            user = User.find(params[:id])
            if user.destroy
                render json: {
                status: "Success",
                    message: "Deleted successfully",
                    data: nil
                }, 
                :status => :ok    
            else
                render json: {
                    error:"Unprocessable entity",
                    message:  "user not found",
                    status_code: 422
                }, 
                :status => :unprocessable_entity 
            end
        rescue => exception
            render json: {
                message: exception, 
                status_code: 500
            },
            :status => :internal_server_error    
        end
    end
    

    # change_password
    def change_password
    auth_id = @current_user.id
       begin
        user = User.find_by(id: auth_id)
        current_password = params[:current_password]
        hashed_password = user[:password_digest]
        is_match = BCrypt::Password.new(hashed_password) == current_password

        if !is_match
            render json: {
            message: "Current password is invalid",
            status_code: 403,
            error: "Forbidden"
        }, 
        status: :forbidden   
        else
            hash_password = BCrypt::Password.create(params[:password])
            user.password_digest = hash_password
            if user.update(password_params)
            render json: {
                message: "password changed successfully",
                status_code: 201,
                status: "Success"
            }, 
            status: :created   
            else
            render json: {
                    error:"Bad request",
                    message:  user.errors.full_messages,
                    status_code: 400
            }, 
            :status => :bad_request 
            end
        end
       rescue => exception
        render json: { 
            message: exception, 
            status_code: 500,
            error:"Internal server error", 
            },
            status: :internal_server_error
       end
    end

    # Forgot password
    def forgot_password       
        begin
        user = User.find_by(email: params[:email])
        if !user
          render json: {
                error:"Bad request",
                message:  'User not found',
                status_code: 400
            }, 
            :status => :not_found
        else
            expired_at = Time.now + 2160
            payload = {id:user.id, exp: expired_at.to_i}
            reset_token = JWT.encode payload, ENV['JWT_SECRET']
            user.reset_token = reset_token
            user.save(validate: false)
            PasswordResetMailer.with(user: user, reset_token: user.reset_token).password_reset.deliver_later
             render json: {
                message: "Password Reset link sent successfully",
                status_code: 201,
                data: {
                    email: user.email
                },
                reset_token: user.reset_token,
                expired_at: expired_at.strftime("%m-%d-%Y %H:%M"),
            }, 
            status: :ok 
        end
        rescue => exception
            render json: { 
            message: exception, 
            status_code: 500,
            error:"Internal server error", 
            },
            status: :internal_server_error
        end
    end

    # Reset Password
    def reset_password
        begin
        reset_token = params[:reset_token]
        decoded_token = JWT.decode reset_token, ENV['JWT_SECRET']
            if !decoded_token
                render json: { 
                    errors: "Unauthorized", 
                    status_code: 401, 
                    message:"Invalid token" ,
                }, 
                status: :unauthorized
            else
               user = User.find_by(reset_token: reset_token)
               if !user
                 render json: {
                    error:"Unprocessable entity",
                    message:  "Invalid token",
                    status_code: 422
                }, 
                :status => :unprocessable_entity 
               else
                    hash_password = BCrypt::Password.create(params[:password])
               user.password_digest = hash_password
               user.reset_token = nil
               if user.update(password_params)
                    render json: {
                    message: "Password reset successfully",
                    status_code: 201,
                    data: {
                        id:user.id
                    },
                    }, 
                    status: :ok 
                else
                    render json: {
                    error:"Bad request",
                    message:  user.errors.full_messages,
                    status_code: 400
                }, 
                :status => :bad_request 
               end 
               end                             
            end        
        rescue => exception
            render json: { 
            message: exception, 
            status_code: 500,
            error:"Internal server error", 
            },
            status: :internal_server_error
        end
    end


    # 
    private
    def user_params
        params.permit(:surname, :email, :password, :password_confirmation, :othername)
    end

    private
     def password_params
        params.permit(:password, :password_confirmation)
    end
end
