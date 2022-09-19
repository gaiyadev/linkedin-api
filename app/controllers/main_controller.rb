class MainController < ApplicationController
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
