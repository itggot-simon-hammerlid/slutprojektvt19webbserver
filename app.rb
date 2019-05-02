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
    create(params)
    redirect('/')
end

get('/login') do
    slim(:login)
end

post('/login') do
    user_id = login(params)
    if user_id
        session[:user_id] = user_id
        redirect('/worm')
    else 
        redirect('/error')
    end
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
    post(params, session)
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
    if alter(params, session)
        redirect('/profile')
    else
        redirect('/login')
    end
end

# post('/alter') do
#     redirect(back)
# end

#before do
#end

#after do
#end


post('/logout') do
    session.clear
    redirect('/')
end

get('/tag_list') do
    slim(:tag_list)
end