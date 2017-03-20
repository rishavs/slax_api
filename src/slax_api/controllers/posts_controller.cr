def index_items
    query = Crecto::Repo::Query
        .order_by("posts.id DESC")
    dataset = Crecto::Repo.all(Post, query)
    dataset.as(Array) unless dataset.nil?

    render "src/Kamel/views/posts/index_posts.ecr", "src/Kamel/views/base.ecr"

end

def add_new_item

    render "src/Kamel/views/posts/new_post.ecr", "src/Kamel/views/base.ecr"
end

def save_new_item(env)
    data = Post.new
    data.title = env.params.body["post_title"]
    data.is_link = false
    data.link = nil
    data.content = env.params.body["post_content"]
    data.author_username = "some guy"
    data.is_viewable = true
    data.is_approved = true
    data.is_deleted = false
    data.last_read_at = Time.new(2016, 2, 15, 10, 20, 30)

    changeset = Crecto::Repo.insert(data)
    puts "Changeset is INVALID!" if changeset.valid? == false
    puts "Changeset errors are: #{changeset.errors }" if !changeset.errors.empty?
    puts "\nThe item was successfully ADDED. ID:#{changeset.instance.id}\n"

    env.redirect "/p/index" 
end

def show_an_item (env)
    id = env.params.url["id"]
    data = Crecto::Repo.get(Post, id)
    if data
        render "src/Kamel/views/posts/show_post.ecr", "src/Kamel/views/base.ecr"
    else
        "Unable to fetch Item data"
    end
end

def edit_an_item(env)
    id = env.params.url["id"]
    data = Crecto::Repo.get(Post, id)
    if data
        render "src/Kamel/views/posts/edit_post.ecr", "src/Kamel/views/base.ecr"    
    else
        "Unable to fetch Item data"
    end
end

def save_edited_item(env)
    id = env.params.url["id"]
    data = Crecto::Repo.get(Post, id)

    if data
        data.title = env.params.body["post_title"]
        data.content = env.params.body["post_content"]

        changeset = Crecto::Repo.update(data)
        puts "Changeset is INVALID!" if changeset.valid? == false
        puts "Changeset errors are: #{changeset.errors }" if !changeset.errors.empty?
        puts "\nThe item was successfully UPDATED. ID:#{changeset.instance.id}\n"

        env.redirect "/p/#{changeset.instance.id}" 
    else
        "Unable to fetch Item data"
    end
end

def delete_an_item(env)
    id = env.params.url["id"]

    post = Crecto::Repo.get(Post, id)
    post.as(Post) unless post.nil?

    if post
        changeset = Crecto::Repo.delete(post)

        puts "Changeset is INVALID!" if changeset.valid? == false
        puts "Changeset errors are: #{changeset.errors }" if !changeset.errors.empty?
        puts "\nThe item was successfully DELETED. ID:#{changeset.instance.id}\n"

        env.redirect "/p/index" 
    else
        "Unable to get the post"
    end
end

