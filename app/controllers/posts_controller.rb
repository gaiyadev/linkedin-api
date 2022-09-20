class PostsController < ApplicationController
     skip_before_action :authorize_request, only: [:index, :show]

      def index
       begin
        posts = Post.all()
        render json: {
            status: "Success",
            status_code: 200,
             message: "Fetched successfully", 
             data: posts
            }, 
            :status => :ok    
       rescue => exception
         render json: {
                message: exception, 
                status_code: 500,
                error: "Internal server error",
            }, 
            :status => :internal_server_error 
       end
      end
    
      def show
        begin
        post = Post.find_by(id: params[:id])
        if !post
         render json: {
            error: "Not found",
            status_code: 404,
            message: "Post not found", 
            }, 
            :status => :not_found    
         else
            render json: {
            status: "Success",
            status_code: 200,
            message: "Fetched successfully", 
            data: post
            }, 
            :status => :ok    
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
    
      def create
        post = Post.new()
        post.title = params[:title]
        post.description = params[:description]
        auth_id = @current_user.id

        begin
              if post.save() 
                return render json: {
                status: "Success", 
                status_code: 201, 
                message: "Post created successfully.", 
                data: {
                    id: post.id,
                }, 
                }, 
                :status => :created 
            else
                render json: {
                    error:"Bad request",
                    message: post.errors.full_messages,
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
    
      def update
        begin
        post = Post.find(params[:id])
        post.title = params[:title]
        post.description = params[:description]
        if post.update() 
                return render json: {
                status: "Success", 
                status_code: 201, 
                message: "Post updated successfully.", 
                data: {
                    id: post.id,
                }, 
                }, 
                :status => :created 
            else
                render json: {
                    error:"Bad request",
                    message: post.errors.full_messages,
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
    
    
      def destroy
        begin
           post = post.find(params[:id])
           if post.destroy
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
                status_code: 500,
                error: "Internal server error",
            }, 
            :status => :internal_server_error 
        end
      end

      def find_by_user_id
        begin
        posts = Post.all().where(user_id: auth_id)
        auth_id = @current_user.id
        render json: {
            status: "Success",
            status_code: 200,
             message: "Fetched successfully", 
             data: posts
            }, 
            :status => :ok 
        rescue => exception
             render json: {
                message: exception, 
                status_code: 500,
                error: "Internal server error",
            }, 
            :status => :internal_server_error 
        end      
      end
end
