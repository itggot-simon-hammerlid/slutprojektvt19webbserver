require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'

require_relative "functions/do_tings"
require_relative "functions/get_tings"

enable :sessions

get('/') do
    slim(:index)
end


get('/register') do
    slim(:register)
end

post('/create') do
    db = SQLite3::Database.new('db/Databasse.db')
    db.results_as_hash = true

    result = db.execute("SELECT username FROM users WHERE username=?", params["Username"])

    if result.length != 0
        redirect('/register')
    end
    
    hashat_password = BCrypt::Password.create(params["Password"])

    db.execute("INSERT INTO users (username, password) VALUES (?, ?)", params["Username"], hashat_password)
    redirect('/')
end

get('/login') do
    slim(:login)
end

post('/login') do
if user_id == login(params)
    session[:user_id] = user_id
    redirect('/worm')
else 
    redirect('/error')
end


get('/error') do
    slim(:error)
end

get('/eroexist') do
    slim(:erroexist)
end

post('/eroexist') do
    db = SQLite3::Database.new('db/Databasse.db')
    db.results_as_hash = true
    #byebug 
    result = db.execute("SELECT * FROM users WHERE username = ? AND password = ?",params["Username"], params["Password"])
    
    if result == []
        redirect('/error')
        #result.first["Password"] 
    else
        redirect('/worm')
    end
end

post('/error') do
    db = SQLite3::Database.new('db/Databasse.db')
    db.results_as_hash = true

    result = db.execute("SELECT * FROM users WHERE username = ? AND password = ?",params["Username"], params["Password"])
    
    if result == []
        redirect('/error')
        #result.first["Password"] 
    else
        redirect('/worm')
    end
end

get('/worm') do
    slim(:worm)
end

get('/profile') do
    db = SQLite3::Database.new('db/Databasse.db')
    db.results_as_hash = true

    users = db.execute("SELECT * FROM users")
    
    slim(:profile, locals:{users: users})
end

post('/post') do
    db = SQLite3::Database.new('db/Databasse.db')
    db.results_as_hash = true
    
    new_file_name = SecureRandom.uuid
    temp_file = params["image"]["tempfile"]
    path = File.path(temp_file)

    new_file = FileUtils.copy(path, "./public/img/#{new_file_name}")

    db.execute("INSERT INTO posts (content, picture, userId) VALUES (?, ?, ?)",
        [
            params["Text"],
            new_file_name,
            session['user']
        ]
    )
    # name = db.execute("SELECT username FROM users WHERE id=?" , [session["user"]])
    redirect('/profile')
end



get('/posts') do
    db = SQLite3::Database.new('db/Databasse.db')
    db.results_as_hash = true

    result = db.execute("SELECT * FROM posts")

    slim(:posts, locals:{users_posts: result})
end

get('/posts/:id') do
    db = SQLite3::Database.new('db/Databasse.db')
    db.results_as_hash = true

    result = db.execute("SELECT * FROM posts WHERE userId=?", [params["id"]])

    unam = db.execute("Select username FROM users WHERE username=?", [params[""]])

    slim(:posts, locals:{users_posts: result, users_author: result})
end

#configure do
#    set :error_messages, {
#        login_failed: "Login failed!!!"
#       ... etc
#    }
#    settings.error[:login_failed]
#end

post('/alter/:id') do
    db = SQLite3::Database.new('db/Databasse.db')
    db.results_as_hash = true
    
    new_file_name = SecureRandom.uuid
    temp_file = params["image"]["tempfile"]
    path = File.path(temp_file)

    new_file = FileUtils.copy(path, "./public/img/#{new_file_name}")

    db.execute("REPLACE INTO posts (content, picture, userId, id) VALUES (?, ?, ?, ?)",
        [
            params["Text"],
            new_file_name,
            session['user'],
            (här skall jag skriva id)
        ]
    )
    # name = db.execute("SELECT username FROM users WHERE id=?" , [session["user"]])
    redirect('/profile')
end

get('/alter') do
    redirect('/alter')
end

before do
end

after do
end


get('/logout') do
    session.clear
    redirect('/')
end

