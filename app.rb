require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require 'json'

require_relative "functions/DoTings"
require_relative "functions/GetTings"

enable :sessions

# Display Starting Page
#
get('/') do
    slim(:index)
end


# Display Register Page
#
get('/register') do
    slim(:register)
end

# Creates account and redirects to starting page
#
# @param [String] username, The username
# @param [String] password, The password
#
# @see DoTings#create 
post('/create') do
    create(params)
    redirect('/')
end

# Display Login Page
#
get('/login') do
    slim(:login)
end

# Checks if account exists and logs into account
#
# @param [String] username, The username
# @param [String] password, The password
#
# @see DoTings#login
post('/login') do
    user_id = login(params)
    if user_id
        session[:user_id] = user_id
        redirect('/worm')
    else 
        redirect('/error')
    end
end

# Display Login Page with error message
#
get('/error') do
    slim(:error)
end

# Display Login Page with error message
#
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

# Redirects to login site with error message if the user tries to login with incorrect credentials
#
# @param [String] username, The username
# @param [String] password, The password
#
# @see DoTings#error
post('/error') do
    if error(params)
        redirect('/error')
    else
        redirect('/worm')
    end
end

# Display Logged-in Page
#
get('/worm') do
    slim(:worm)
end

# Display Profile Page
#
# @see GetTings#profile
get('/profile') do
    users = profile()
    slim(:profile, locals:{users: users})
end

# Creates a new post and redirects to profile page
#
# @param [String] image, a submitted image
# @param [String] Text, text submitted to be posted
# @param [String] tag, the tag name
#
# @see DoTings#post
post('/post') do
    post(params, session)
    redirect('/profile')
end

# Display posts of all users
#
# @see GetTings#getposts
get('/posts') do
    result = getposts()
    slim(:posts, locals:{users_posts: result})
end

# Display posts of user chosen
#
# @param [Integer] id, The user_id of the chosen account
#
# @see GetTings#getpostsbyuserid
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

# Replaces selected post and redirects to profile page
#
# @param [String] image, a submitted image
# @param [String] Text, text submitted to be posted
# @param [String] tag, the tag name
#
# @see DoTings#alter
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


# Logs out of account and redirects to starting page
#
# @see DoTings#logout
post('/logout') do
    logout(session)
    redirect('/')
end

#
#
# @see GetTings#tag_list
get('/tag_list') do
    result = tag_list()
    slim(:tag_list, locals:{topics: result})
end

# 
#
# @see GetTings#scienceposts
get('/tags/science') do
    result = scienceposts()
    slim(:sciencetag, locals:{content: result})
end

#
#
# @see GetTings#mathposts
get('/tags/math') do
    result = mathposts()
    slim(:mathtag, locals:{content: result})
end