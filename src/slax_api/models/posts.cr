class Post < Crecto::Model

    schema "posts" do
        field :title,           String
        field :is_link,         Bool
        field :link,            String
        field :content,         String
        field :author_username, String
        field :is_viewable,     Bool
        field :is_approved,     Bool
        field :is_deleted,      Bool
        field :last_read_at,    Time
    end
    
    validate_required [:title]
end
