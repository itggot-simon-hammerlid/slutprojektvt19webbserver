require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require 'json'

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

#post('/erroexist') do
#    if erroexist(params)
#        redirect('/error')
#    else
#        redirect('/worm')
#    end
#end

post('/error') do
    if error(params)
        redirect('/error')
    else
        redirect('/worm')
    end
end

get('/worm') do
    slim(:worm)
end

get('/profile') do
    users = profile()
    slim(:profile, locals:{users: users})
end

post('/post') do
    post(params, session)
    redirect('/profile')
end


get('/posts') do
    result = getposts()
    slim(:posts, locals:{users_posts: result})
end

get('/posts/:id') do
    unam, result = getpostsbyuserid(params)
    slim(:posts, locals:{users_posts: result, users_author: result, post_author: unam})
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
    logout(session)
    redirect('/')
end

get('/tag_list') do
    result = tag_list()
    slim(:tag_list, locals:{topics: result})
end

get('/tags/science') do
    result = scienceposts()
    slim(:sciencetag, locals:{content: result})
end

get('/tags/math') do
    result = mathposts()
    slim(:mathtag, locals:{content: result})
end