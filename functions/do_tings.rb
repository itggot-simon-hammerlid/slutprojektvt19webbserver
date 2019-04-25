def login(params)
    db = SQLite3::Database.new('db/Databasse.db')
    db.results_as_hash = true
    pass = db.execute("SELECT id, password FROM users WHERE username = ?",params["Username"])
    
    if pass.length == 0
        return false
    end
    
    if BCrypt::Password.new(pass[0]["password"]) == params["Password"]

        return pass[0]['id']
    else
        return false
    end
end