require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    it "returns all posts" do
      Post.create!(title: "Post 1", content: "Content 1", author: "Author 1")
      Post.create!(title: "Post 2", content: "Content 2", author: "Author 2")
      get "/posts"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe "GET /post/:id" do
    it "returns a single post using post id" do
      post = Post.create!(title: "Post 1",content: "Content 1", author: "Author 1")
      get "/posts/#{post.id}"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).key?("title")).to be true
      expect(JSON.parse(response.body).key?("content")).to be true
      expect(JSON.parse(response.body).key?("author")).to be true
    end
  end

  describe "POST /posts" do
    it "returns the newly added post" do
      post_body = {
        title: "This is title",
        content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        author: "Rishi"
      }
      post "/posts",
      params: post_body.to_json,
      headers: {
        "Content-Type" => "application/json",
        "Accept" => "*/*"
      }
  
      expect(response).to have_http_status(:created)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response["title"]).to eq(post_body[:title])
      expect(parsed_response["content"]).to eq(post_body[:content])
      expect(parsed_response["author"]).to eq(post_body[:author])
      end
  end

  describe "PATCH /posts/:id" do
    it "updates existing post using id" do
      post = Post.create!(title: "Post 1",content: "Content 1", author: "Author 1")
      updt = {
        title: "Updated title"
      }
      patch "/posts/#{post.id}",
        params: updt.to_json,
        headers: { 
          "Content-Type" => "application/json",
          "Accept" => "*/*" 
        }

        expect(response).to have_http_status(:ok) 
        json_response = JSON.parse(response.body)
        expect(json_response["title"]).to eq("Updated title")
    end
  end

  describe "DELETE posts/:id" do
    it "deletes a post" do
      post = Post.create!(title: "Title to Delete", content: "Content to Delete", author: "Author")

      expect {
        delete "/posts/#{post.id}",
          headers: {
            "Accept" => "application/json" 
          } 
        }.to change { Post.count }.by(-1)
    
        expect(response).to have_http_status(:no_content)
    end
  end
end
