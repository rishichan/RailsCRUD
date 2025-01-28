# app/api/base.rb
class Base < Grape::API
    prefix :api         # API routes will be prefixed with '/api'
    format :json        # Responses will be in JSON format
    version "v1", using: :path  # API versioning using the path (like /api/v1/)

    # Mount your resource-specific APIs here (e.g., Users, Articles, etc.)
    mount V1::Posts
end
