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

# Creates account and redirects to starting page, sends error message if incorrect input
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
# @param [Hash] params, form data
# @option params [String] username, The username
# @option params [String] password, The password
#
# @return [Hash]
#   * :error [String] whether an error ocurred
# @return [Hash]
#   * :id [Integer] The ID of the user 
#   * :success [String] message displayed if login was successful
# @return [Hash]
#   * :error [String] whether an error ocurred
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

=begin
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
# @see Model#error
post('/error') do
    if error(params)
        redirect('/error')
    else
        redirect('/accessed')
    end
end
=end

# Checks if visitor is logged in and displays logged in page
# 
# @return [Hash]
#   * :error [String] if user is not logged in
#
# @return [Hash]
#   * :success [String] if user is logged in
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

# Display Profile Page
#
# @see Model#profile
get('/profile') do
    users = profile()
    slim(:profile, locals:{users: users})
end

# Attempts to insert a new row into the posts table
#
# @param [Hash] params, form data
# 
# @return [Hash]
#   * :error [String] whether an error ocurred
#
# @option param [Blob] image, the image submitted
#
# @option param [String] content, The text in the blog
# @option param [String] tag, The tag of the post
#
# @return [Hash]
#   * :success [String] message sent if post was successful
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

# Display posts of all users
#
# @see GetTings#getposts
get('/posts') do
    result = getposts()
    slim(:posts, locals:{users_posts: result})
end

# Display posts of user chosen
#
# @param [Hash] params, form data
#
# @option params [Integer] id, The user_id of the chosen account
#
# @see Model#getpostsbyuserid
get('/posts/:id') do
    unam, result = getpostsbyuserid(params)
    slim(:posts, locals:{users_posts: result, users_author: result, post_author: unam})
end

# Attempts to replace a row in the posts table
#
# @param [Hash] params, form data
#
# @option param [Blob] image, the image submitted
#
# @option param [String] content, The text in the blog
# @option param [String] tag, The tag of the post
#
# @see Model#alter
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
# @see Model#logout
post('/logout') do
    session.clear
    redirect('/')
end

# Display list of tags
#
# @see Model#tag_list
get('/tag_list') do
    result = tag_list()
    slim(:tag_list, locals:{topics: result})
end

# Display posts with the science tag
#
# @see Model#scienceposts
get('/tags/science') do
    result = scienceposts()
    slim(:sciencetag, locals:{content: result})
end

# Display posts with the math tag
#
# @see Model#mathposts
get('/tags/math') do
    result = mathposts()
    slim(:mathtag, locals:{content: result})
end