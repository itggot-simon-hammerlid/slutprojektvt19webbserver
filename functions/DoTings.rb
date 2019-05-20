def login(params)
    db = SQLite3::Database.new('db/Databasse.db')
    db.results_as_hash = true
    pass = db.execute("SELECT id, password FROM users WHERE username = ?",params["Username"])
    
    if pass.length == 0
        return {error: "failed"}
    end
    
    if BCrypt::Password.new(pass[0]["password"]) == params["Password"]

        return {id: pass[0]['id'], success: "Logged in"}
    else
        return {error: "failed"}
    end
end

def create_account(params)
    db = SQLite3::Database.new('db/Databasse.db')
    db.results_as_hash = true

    result = db.execute("SELECT username FROM users WHERE username=?", params["Username"])

    if result.length != 0
        return {error: "user already exists"}
    end
    
    hashat_password = BCrypt::Password.create(params["Password"])

    db.execute("INSERT INTO users (username, password) VALUES (?, ?)", params["Username"], hashat_password)
    return {success: "Registered"}
end

def post(params, session)
    if session[:user_id] == nil
        redirect('/login')
    else
        db = SQLite3::Database.new('db/Databasse.db')
        db.results_as_hash = true
        
        new_file_name = SecureRandom.uuid
        temp_file = params["image"]["tempfile"]
        path = File.path(temp_file)

        new_file = FileUtils.copy(path, "./public/img/#{new_file_name}")

        #tag = db.execute("SELECT id FROM tags WHERE name=?",[params['text']])[0]

        db.execute("INSERT INTO posts (content, picture, userId, tagId) VALUES (?, ?, ?, ?)",
            [
                params["Text"],
                new_file_name,
                session[:user_id],
                params["tag"] 
            ]
        )
    end
end

def alter(params, session)
    if session[:user_id] == nil
        return false
    else
        db = SQLite3::Database.new('db/Databasse.db')
        db.results_as_hash = true
        
        new_file_name = SecureRandom.uuid
        temp_file = params["image"]["tempfile"]
        path = File.path(temp_file)

        #tag = db.execute("SELECT id FROM tags WHERE name=?",[params['text']])[0]

        new_file = FileUtils.copy(path, "./public/img/#{new_file_name}")

        db.execute("REPLACE INTO posts (content, picture, userId, tagId) VALUES (?, ?, ?, ?)",
            [
                params["Text"],
                new_file_name,
                session[:user_id],
                params["tag"]
                #params["id"]
            ]
        )
        # name = db.execute("SELECT username FROM users WHERE id=?" , [session["user"]])
        return true
    end
end

def error(params)
    db = SQLite3::Database.new('db/Databasse.db')
    db.results_as_hash = true

    result = db.execute("SELECT * FROM users WHERE username = ? AND password = ?",params["Username"], params["Password"])
    
    if result == []
        return true
        #result.first["Password"] 
    else 
        return false
    end
end

# def eroexist(params)
#     db = SQLite3::Database.new('db/Databasse.db')
#     db.results_as_hash = true
#     #byebug 
#     result = db.execute("SELECT * FROM users WHERE username = ? AND password = ?",params["Username"], params["Password"])
    
#     if result == []
#         redirect('/error')
#         #result.first["Password"] 
#     else
#         redirect('/worm')
#     end 
# end
#inte klar, tror det är sammma som error funktionen