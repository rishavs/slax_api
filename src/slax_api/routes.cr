get "/p/index" do 
	index_items 
end

get "/p/new" do 
	add_new_item 
end
  	
post "/p/new" do |env|
	save_new_item(env)
end

get "/p/:id" do |env|
	show_an_item(env)
end

get "/p/:id/edit" do |env|
	edit_an_item(env)
end	

patch "/p/:id" do |env|
	save_edited_item(env)
end

delete "/p/:id" do |env|
	delete_an_item(env)
end	






#---------------------------------------------------------------------------------------

# Redirect browser
get "/foo" do |env|
  	# important stuff like clearing session etc.
 	env.redirect "/bar" # redirect to /bar page
end
get "/bar" do 
	"type foo get bar"
end


get "/error" do |env|
    env.response.status_code = 403
end


error 404 do
    "This is a customized 404 page."
end

error 403 do
    "Access Forbidden!"
end

get "/" do
	"Hello World!"
end

