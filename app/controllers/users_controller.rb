class UsersController < ApplicationController
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
                # 
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
                        message:  user.errors.full_messages,
                        status_code: 400
                    }, 
                    :status => :bad_request 
            end
        rescue => exception
            render json: {
                message: exception, status_code: 500,
                error:"Internal server error",
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
                error:"Not found",
                message:  "Invalid otp",
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
                error:"Not found",
                message:  "User not found",
                status_code: 404
            }, 
                :status => :not_found 
        end
        end       
        rescue => exception
              render json: {
                message: exception, status_code: 500,
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
            # token = encode_token({user_id: user.id, email: user.email})
            render json: {
                status: "Success",
                 message: "Login successfully",
                  data: {
                    email: user.email,
                     id: user.id
            }, 
            token: nil
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
            render json: { error: exception }, status: :internal_server_error
        end   
    end
    # 
    def user_params
        params.permit(:surname, :email, :password, :password_confirmation, :othername)
    end
end
