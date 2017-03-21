require "pg"
require "crecto"

module Models
    class User < Crecto::Model
        schema "users" do
            field :name,            String
            field :email,           String
            field :gender,          String
            field :is_adult,        Bool
            field :is_admin,        Bool
            field :is_mod,          Bool
            field :is_loggedin,     Bool
            field :auth_provider,   String
            field :client_id,       String
            field :token,           String
            field :last_active_at,  Time

            has_many :posts, Post
        end
        
        validate_required [:name]
        validate_inclusion [:gender], ["male", "female", "other"]
        # validate_length [:name, :email], [min: 5, max: 64]
    end

end