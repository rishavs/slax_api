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

class Post < Crecto::Model
    schema "posts" do
        field :user_id,         Int64
        field :title,           String
        field :slug,            String
        field :content,         String
        field :thumb,           String
        field :is_link,         Bool
        field :link,            String
        field :is_viewable,     Bool
        field :is_approved,     Bool
        field :is_deleted,      Bool
        field :last_read_at,    Time
    
        belongs_to :user, User
    end
    
    validate_required [:user_id, :slug, :title, :content]
    # validate_length [:slug, :thumb, :link, :title], [min: 5, max: 255]
end
