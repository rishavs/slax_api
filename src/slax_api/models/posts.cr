require "pg"
require "crecto"

module Models

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

end