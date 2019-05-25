require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require 'json'

require_relative "functions/DoTings"
require_relative "functions/GetTings"

enable :sessions
include Model

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

# Attempts to create a new user and redirects to starting page
#
# @param [String] username, The username
# @param [String] password, The password
#
# @see Model#create_account
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

# Finds an article
#
# @param [String] username, The username
# @param [String] password, The password
#
# @see Model#login
post('/login') do
    result = login(params)
    if result[:success]
        session[:user_id] = result[:id]
        session[:msg] = result[:success]
        redirect('/accessed')
    else 
        session[:msg] = result[:error]
        #redirect('/error')
        redirect('/login')
    end
end

# Checks if visitor is logged in and displays logged in page
#
get('/accessed') do
    result = accessed()
    if result[:error] 
        session[:msg] = result[:error]
        redirect('/login')
    else
        session[:msg] = result[:success]
        slim(:accessed)
    end
end

# Retrieves and displays all users
#
# @see Model#profile
get('/profile') do
    users = profile()
    slim(:profile, locals:{users: users})
end

# Attempts to insert a new row into the posts table
#
# @param [Hash] image, the image submitted
#
# @param [String] content, The text in the blog
# @param [String] tag, The tag of the post
#
# @see Model#post
post('/post') do
    result = post(params, session)
    if result[:error] 
        session[:msg] = result[:error]
        redirect('/login')
    else
        session[:msg] = result[:success]
        redirect('/profile')
    end
end

# Retrieves and displays all posts
#
# @see GetTings#getposts
get('/posts') do
    result = getposts()
    slim(:posts, locals:{users_posts: result})
end

# Retrieves and displays posts of user chosen
#
# @param [Integer] id, The user_id of the chosen account
#
# @see Model#getpostsbyuserid
get('/posts/:id') do
    unam, result = getpostsbyuserid(params)
    slim(:posts, locals:{users_posts: result, users_author: result, post_author: unam})
end

# Attempts to replace a row in the posts table
#
# @param [Hash] image, the image submitted
#
# @param [String] content, The text in the blog
# @param [String] tag, The tag of the post
#
# @see Model#alter
post('/alter/:id') do
    result = alter(params, session)
    if result[:error] 
        session[:msg] = result[:error]
        redirect('/login')
    else
        session[:msg] = result[:success]
        redirect('/profile')
    end
end

# post('/alter') do
#     redirect(back)
# end


# Logs out of account and redirects to starting page
#
# @see Model#logout
post('/logout') do
    session.clear
    redirect('/')
end

# Retrieves and displays all tag names
#
# @see Model#tag_list
get('/tag_list') do
    result = tag_list()
    slim(:tag_list, locals:{topics: result})
end

# Retrieves and displays all posts with the science tag
#
# @see Model#scienceposts
get('/tags/science') do
    result = scienceposts()
    slim(:sciencetag, locals:{content: result})
end

# Retrieves and displays all posts with the math tag
#
# @see Model#mathposts
get('/tags/math') do
    result = mathposts()
    slim(:mathtag, locals:{content: result})
end