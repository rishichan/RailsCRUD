module V1
    class Posts < Grape::API
        resource :posts do
            get do
                Post.all
            end

            get ":id" do
                Post.find(params[:id])
            end

            params do
                requires :title, type: String, desc: "Post Title"
                requires :content, type: String, desc: "Post Content"
                requires :author, type: String, desc: "Post Author"
            end
            post do
                Post.create!(declared(params))
            end

            params do
                requires :id, type: Integer, desc: "Post ID"
                optional :title, type: String, desc: "Post Title"
                optional :content, type: String, desc: "Post Content"
                optional :author, type: String, desc: "Post Author"
            end
            patch ":id" do
                post = Post.find_by(id: params[:id])
                error!("Post not found", 404) unless post

                update_params = {
                    title: params[:title] || post.title,
                    content: params[:content] || post.content,
                    author: params[:author] || post.author
                }

                post.update!(update_params)
                post
            end

            params do
              requires :id, type: Integer, desc: "Post ID"
            end
            delete ":id" do
              post = Post.find_by(id: params[:id])
              error!("Post not found", 404) unless post
              post.destroy
              { message: "Post deleted successfully" }
            end
        end
    end
end
