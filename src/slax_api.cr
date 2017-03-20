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
	    field :gender, 			Int64
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
end

class Post < Crecto::Model
    schema "posts" do
		field :user_id, 		Int32
        field :title,           String
        field :slug,           	String
        field :is_link,         Bool
        field :link,            String
        field :content,         String
        field :is_viewable,     Bool
        field :is_approved,     Bool
        field :is_deleted,      Bool
        field :last_read_at,    Time
	
        belongs_to :user, User
    end
    
    validate_required [:title, :content]
end





get "/" do |env|
  	env.response.content_type = "application/json"
  	{name: "Serdar", age: 27}.to_json
end

get "/Hello" do
  	"Hello World!"
end


def create_user(env)

	puts "POST request received for data:"

	# data = User.from_json(env.params.json)

    data 				= User.new
	data.name 			= env.params.json["name"].as(String)
    data.email 			= env.params.json["email"].as(String)
    data.gender 		= env.params.json["gender"].as(Int64).to_i32
    data.is_adult 		= env.params.json["is_adult"].as(Bool)
    data.is_admin 		= env.params.json["is_admin"].as(Bool)
    data.is_mod 		= env.params.json["is_mod"].as(Bool)
    data.is_loggedin 	= env.params.json["is_loggedin"].as(Bool)
    data.auth_provider 	= env.params.json["auth_provider"].as(String)
    data.client_id 		= env.params.json["client_id"].as(String)
    data.token 			= env.params.json["token"].as(String)
    # data.last_active_at = env.params.json["last_active_at"].as(Time)

    changeset = Crecto::Repo.insert(data)
	if changeset.valid? == false
	    puts "Changeset is INVALID!" 
		env.response.status_code = 400
		"This is a customized 404 page."
		puts "Changeset errors are: #{changeset.errors }" if !changeset.errors.empty?
	end
    puts "\nThe item was successfully ADDED. ID:#{changeset.instance.id}\n"

    # env.redirect "/p/index" 
end

# models Posts
# get "/api/v0.1.0/posts/index" do 
# 	index_items 
# end

# post "/api/v0.1.0/posts/create" do |env|
# 	create_item(env)
# end

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
# get "/api/v0.1.0/users/index" do 
# 	index_items 
# end

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

error 404 do
  "This is a customized 404 page."
end
# error 404 do
#   "This is a customized 404 page."
# end
# error 404 do
#   "This is a customized 404 page."
# end

Kemal.run

