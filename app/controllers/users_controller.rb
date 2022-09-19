class UsersController < ApplicationController
    def sign_up
        return render json: {
            status: "Success", 
            status_code: 201, 
            message: "sign up to linkedIn clone api", 
            data: {
                id: nil
            }, 
            }, 
            :status => :created         
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
end
