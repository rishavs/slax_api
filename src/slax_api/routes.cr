
# models Posts
get "/api/v0.1.0/posts" do |env| 
	index_posts(env)
end

post "/api/v0.1.0/posts/create" do |env|
	create_post(env)
end

get "/api/v0.1.0/posts/:id" do |env|
	show_post(env)
end

# patch "/api/v0.1.0/posts/:id" do |env|
# 	save_post(env)
# end

# delete "/api/v0.1.0/posts/:id" do |env|
# 	delete_post(env)
# end	

# models Users
get "/api/v0.1.0/users" do |env|
	index_users(env)
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

