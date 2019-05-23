# Checks if visitor is logged in
# 
# @return [Hash]
#   * :error [String] if user is not logged in
#
# @return [Hash]
#   * :success [String] if user is logged in
#
def accessed()
    if session[:user_id] == nil
        return {error: "Not logged in"}
    else
        return {success: "Logged in"}
    end
end

# Retrieves all posts
#
# @return [Array] containing the data of all posts
#
def getposts()
    db = SQLite3::Database.new('db/Databasse.db')
    db.results_as_hash = true

    result = db.execute("SELECT * FROM posts")
    return result
end

# Display posts of user chosen
#
# @param [Hash] params, form data
#
# @option params [Integer] id, The user_id of the chosen account
#
# @return [Array] containing the data of all posts from a specific user
# @return [Array] containing the username from a specific user
#
def getpostsbyuserid(params)
    db = SQLite3::Database.new('db/Databasse.db')
    db.results_as_hash = true

    result = db.execute("SELECT * FROM posts WHERE userId=?", [params["id"]])

    unam = db.execute("Select username FROM users WHERE id=?", [params["id"]])

    return unam, result
end

# Retrieves all users
#
# @return [Array] containing the data of all users
#
def profile()
    db = SQLite3::Database.new('db/Databasse.db')
    db.results_as_hash = true

    users = db.execute("SELECT * FROM users")
    return users
end

# Retrieves all tag names
#
# @return [Array] containing the data of all tag names
#
def tag_list()
    db = SQLite3::Database.new('db/Databasse.db')
    db.results_as_hash = true

    result = db.execute("SELECT name FROM tags")
    return result
end

# Retrieves all posts with the math tag
#
# @return [Array] containing the data of all posts for posts with math tag
#
def mathposts()
    db = SQLite3::Database.new('db/Databasse.db')
    db.results_as_hash = true

    result = db.execute("SELECT * FROM posts WHERE tagId=?", "math")   
    return result
end

# Retrieves all posts with the science tag
#
# @return [Array] containing the data of all posts for posts with science tag
#
def scienceposts()
    db = SQLite3::Database.new('db/Databasse.db')
    db.results_as_hash = true

    result = db.execute("SELECT * FROM posts WHERE tagId=?", "science")
    return result
end