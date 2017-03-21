# require "./slax_api/*"
require "kemal"
require "ecr"
require "dotenv"
require "pg"
require "crecto"
# require "yaml"

# secret = YAML.parse(File.read("./src/slax_api/secret.yml"))
# PG_URL =  secret["PG_URL"]

Dotenv.load

class User < Crecto::Model
    schema "users" do
	    field :name, 			String
	    field :email, 			String
	    field :gender, 			String
	    field :is_adult, 		Bool
	    field :is_admin, 		Bool
	    field :is_mod, 			Bool
	    field :is_loggedin, 	Bool
	    field :auth_provider, 	String
	    field :client_id, 		String
	    field :token, 			String
	    field :last_active_at, 	Time

	    has_many :posts, Post
    end
    
    validate_required [:name]
    validate_inclusion [:gender], ["male", "female", "other"]
    # validate_length [:name, :email], [min: 5, max: 64]
end

class Post < Crecto::Model
    schema "posts" do
		field :user_id, 		Int64
        field :title,           String
        field :slug,           	String
        field :content,         String
        field :thumb,         	String
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



get "/" do |env|
  	env.response.content_type = "application/json"
  	{name: "Serdar", age: 27}.to_json
end

get "/Hello" do
  	"Hello World!"
end

def create_post(env)

	puts "POST request received for data:"

	pp env.params.json

    data = Post.new

    begin
    	# data = User.from_json(env.params.json)
		
		data.title 			= env.params.json["title"].as(String)
	    data.slug 			= env.params.json["slug"].as(String)
	    data.content 		= env.params.json["content"].as(String)
	    data.link 			= env.params.json["link"].as(String)
	    data.thumb 			= env.params.json["thumb"].as(String)
	    data.user_id		= env.params.json["user_id"].as(Int64)

	rescue ex : JSON::ParseException
		env.response.status_code = 400
	rescue ex : TypeCastError | KeyError
		env.response.status_code = 422
	else
	    pp data

        changeset = Crecto::Repo.insert(data)
		if changeset.valid? == false
		    puts "Changeset is INVALID!" 
			env.response.status_code = 500
			puts "Changeset errors are: #{changeset.errors }" if !changeset.errors.empty?
		else
	    	puts "\nThe item was successfully ADDED. ID:#{changeset.instance.id}\n"

    		env.response.content_type = "application/json"
			{ "message": "SUCCESS: Item added as id:#{changeset.instance.id}",
				"data": data}.to_json
		end
	end



    # env.redirect "/p/index" 
end


def create_user(env)

	puts "POST request received for data:"

	pp env.params.json

    data = User.new

    begin
    	# data = User.from_json(env.params.json)
		
		data.name 			= env.params.json["name"].as(String)
	    data.email 			= env.params.json["email"].as(String)
	    data.gender 		= env.params.json["gender"].as(String)
	    # data.is_adult 		= env.params.json["is_adult"].as(Bool)
	    # data.is_admin 		= env.params.json["is_admin"].as(Bool)
	    # data.is_mod 		= env.params.json["is_mod"].as(Bool)
	    # data.is_loggedin 	= env.params.json["is_loggedin"].as(Bool)
	    # data.auth_provider 	= env.params.json["auth_provider"].as(String)
	    # data.client_id 		= env.params.json["client_id"].as(String)
	    # data.token 			= env.params.json["token"].as(String)
	    # data.last_active_at = env.params.json["last_active_at"].as(Time)

	rescue ex : JSON::ParseException
		env.response.status_code = 400
	rescue ex : TypeCastError | KeyError
		env.response.status_code = 422
	else
	    pp data

        changeset = Crecto::Repo.insert(data)
		if changeset.valid? == false
		    puts "Changeset is INVALID!" 
			env.response.status_code = 500
			puts "Changeset errors are: #{changeset.errors }" if !changeset.errors.empty?
		else
	    	puts "\nThe item was successfully ADDED. ID:#{changeset.instance.id}\n"

    		env.response.content_type = "application/json"
			{ "message": "SUCCESS: Item added as id:#{changeset.instance.id}",
				"data": data}.to_json
		end
	end



    # env.redirect "/p/index" 
end

def index_users
    query = Crecto::Repo::Query
        .order_by("users.id DESC")
    dataset = Crecto::Repo.all(User, query)
    dataset.to_json unless dataset.nil?

end

def index_posts
    query = Crecto::Repo::Query
        .order_by("posts.id DESC")
    dataset = Crecto::Repo.all(Post, query)
    dataset.to_json unless dataset.nil?

end

# models Posts
get "/api/v0.1.0/posts" do 
	index_posts 
end

post "/api/v0.1.0/posts/create" do |env|
	create_post(env)
end

# get "/api/v0.1.0/posts/:id" do |env|
# 	show_item(env)
# end

# patch "/api/v0.1.0/posts/:id" do |env|
# 	save_item(env)
# end

# delete "/api/v0.1.0/posts/:id" do |env|
# 	delete_item(env)
# end	

# models Users
get "/api/v0.1.0/users" do 
	index_users
end

post "/api/v0.1.0/users/create" do |env|
	create_user(env)
end

# get "/api/v0.1.0/users/:id" do |env|
# 	show_item(env)
# end

# patch "/api/v0.1.0/users/:id" do |env|
# 	save_item(env)
# end

# delete "/api/v0.1.0/users/:id" do |env|
# 	delete_item(env)
# end	

error 400 do |env|
	env.response.content_type = "application/json"
	{ "message": "ERROR: 400 Bad Request",
		"hint": "Check the input data format" }.to_json
end

error 401 do |env|
	env.response.content_type = "application/json"
	{ "message": "ERROR: 401 Unauthorized Request." ,
		"hint": "You need to be authenticated to use this resource"}.to_json
end

error 403 do |env|
	env.response.content_type = "application/json"
	{ "message": "ERROR: 403 Forbidden." ,
		"hint": "You may not be authorized to access a this resource"}.to_json
end

error 404 do |env|
	env.response.content_type = "application/json"
	{ "message": "ERROR: 404 Not Found",
		"hint": "Check the URL used"}.to_json
end

error 422 do |env|
	env.response.content_type = "application/json"
	{ "message": "ERROR: 422 Unprocessable Entity",
		"hint": "Check the input data for invalid entries" }.to_json
end

error 500 do |env|
	env.response.content_type = "application/json"
	{ "message": "ERROR: 500 Internal Server Error",
		"hint": "This exception is not yet explicitly handled. Reach out to the dev." }.to_json
end



Kemal.run

