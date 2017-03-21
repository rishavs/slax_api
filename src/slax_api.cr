require "kemal"
require "ecr"
require "dotenv"
require "pg"
require "crecto"

require "./slax_api/models.cr"
# require "./slax_api/controllers.cr"
require "./slax_api/routes.cr"



Dotenv.load






# get "/" do |env|
#   	env.response.content_type = "application/json"
#   	{name: "Serdar", age: 27}.to_json
# end

# get "/Hello" do
#   	"Hello World!"
# end

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


Kemal.run

