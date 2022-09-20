class MainController < ApplicationController
    skip_before_action :authorize_request, only: [:index]

    def index
        return render json: {
            status: "Success", 
            status_code: 200, 
            message: "Welcome to linkedIn clone api", 
            data: nil, 
            version: 1..0.0
            }, 
            :status => :ok    
    end
end
