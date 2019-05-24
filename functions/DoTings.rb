module Model
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
    def login(params)
        db = SQLite3::Database.new('db/Databasse.db')
        db.results_as_hash = true
        pass = db.execute("SELECT id, password FROM users WHERE username = ?",params["Username"])
        
        if pass.length == 0
            return {error: "Incorrect username"}
        end
        
        if BCrypt::Password.new(pass[0]["password"]) == params["Password"]

            return {id: pass[0]['id'], success: "Logged in"}
        else
            return {error: "Incorrect password"}
        end
    end

    # Attempts to create a new user
    #
    # @param [Hash] params, form data
    # @option params [String] username, The username
    # @option params [String] password, The password
    #
    # @return [Hash]
    #   * :error [String] whether an error ocurred
    # @return [Hash]
    #   * :success [String] message sent if register was successful
    #
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

    # Attempts to insert a new row into the posts table
    #
    # @param [Hash] params, form data
    # 
    # @option params [Blob] image, the image submitted
    #
    # @option params [String] content, The text in the blog
    # @option params [String] tag, The tag of the post
    #
    # @return [Hash]
    #   * :error [String] whether an error ocurred
    # @return [Hash]
    #   * :success [String] message sent if post was successful
    #
    def post(params, session)
        if session[:user_id] == nil
            return {error: "Not logged in"}
        else
            db = SQLite3::Database.new('db/Databasse.db')
            db.results_as_hash = true
            
            new_file_name = SecureRandom.uuid
            temp_file = params["image"]["tempfile"]
            path = File.path(temp_file)

            new_file = FileUtils.copy(path, "./public/img/#{new_file_name}")

            #tag = db.execute("SELECT id FROM tags WHERE name=?",[params['text']])[0]

            db.execute("INSERT INTO posts (content, picture, userId, tagName) VALUES (?, ?, ?, ?)",
                [
                    params["Text"],
                    new_file_name,
                    session[:user_id],
                    params["tag"] 
                ]
            )
            return {success: "Post successful"}
        end
    end

    # Attempts to replace a row in the posts table
    #
    # @param [Hash] params, form data
    # @option params [Blob] image, the image submitted
    # @option params [String] content, The text in the blog
    # @option params [String] tag, The tag of the post
    #
    # @return [false] whether user is logged in
    # @return [true] user is logged in
    def alter(params, session)
        if session[:user_id] == nil
            return false
        else
            db = SQLite3::Database.new('db/Databasse.db')
            db.results_as_hash = true
            
            new_file_name = SecureRandom.uuid #en random sträng, x lång, 
            temp_file = params["image"]["tempfile"]
            path = File.path(temp_file)

            #tag = db.execute("SELECT id FROM tags WHERE name=?",[params['text']])[0]

            new_file = FileUtils.copy(path, "./public/img/#{new_file_name}")

            db.execute("REPLACE INTO posts (content, picture, userId, tagName) VALUES (?, ?, ?, ?)",
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

=begin    #
    #
    # @return [Boolean]
    #
    # @return [Boolean]
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
=end 
end 

