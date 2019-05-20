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

# Creates account and redirects to starting page, sends error message if incorrect input
#
# @param [String] username, The username
# @param [String] password, The password
#
# @see DoTings#create_account
post('/create_account') do
    result = create_account(params)
    if result[:error]
        session[:error] = true
        session[:msg] = result[:error]
        #session[:user_id] = login(params)
        
        redirect back
    else
        session[:msg] = result[:success]
        redirect('/')
    end
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
    result = login(params)
    if result[:success]
        session[:user_id] = result[:id]
        session[:msg] = result[:success]
        redirect('/worm')
    else 
        session[:msg] = result[:error]
        redirect('/error')
    end
end

# Display Login Page with error message
#
get('/error') do
    slim(:error)
end


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
# @param [Integer] :id, the user that wants to alter their post
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
    session.clear
    redirect('/')
end

# Display list of tags
#
# @see GetTings#tag_list
get('/tag_list') do
    result = tag_list()
    slim(:tag_list, locals:{topics: result})
end

# Display posts with the science tag
#
# @see GetTings#scienceposts
get('/tags/science') do
    result = scienceposts()
    slim(:sciencetag, locals:{content: result})
end

# Display posts with the math tag
#
# @see GetTings#mathposts
get('/tags/math') do
    result = mathposts()
    slim(:mathtag, locals:{content: result})
end