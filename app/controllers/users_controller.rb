class UsersController < ApplicationController
    def sign_up
        begin
            user = User.new(user_params)
            # user.email = params[:email]

            if user.save()                 
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

    # Sign in
    def sign_in
        return render json: {
            status: "Success", 
            status_code: 201, 
            message: "sign in to linkedIn clone api", 
            data: {
                id: nil
            }, 
            }, 
            :status => :created         
    end
    # 
    def user_params
        params.permit(:surname, :email, :password, :password_confirmation, :othername)
    end
end
