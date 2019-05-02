def getposts()
    db = SQLite3::Database.new('db/Databasse.db')
    db.results_as_hash = true

    result = db.execute("SELECT * FROM posts")
    return result
end

def getpostsbyuserid(params)
    db = SQLite3::Database.new('db/Databasse.db')
    db.results_as_hash = true

    result = db.execute("SELECT * FROM posts WHERE userId=?", [params["id"]])

    unam = db.execute("Select username FROM users WHERE id=?", [params["id"]])

    return unam, result
end

def profile()
    db = SQLite3::Database.new('db/Databasse.db')
    db.results_as_hash = true

    users = db.execute("SELECT * FROM users")
    return users
end