class SessionsController < ApplicationController

  def create
    auth_hash = request.env['omniauth.auth']

    if auth_hash[:uid]
      @user = User.find_by(uid: auth_hash[:uid], provider: 'github')
      if @user.nil?

        # User doesn't match anything in the DB
        # Attempt to create a new user

        user = User.build_from_github(auth_hash)

        if user.save
            # saved successfully
            session[:user_id] = user.id
            flash[:success] = "Logged in successfully"
            redirect_to root_path
        else
            # not saved successfully

            flash[:error] = "Could not log in"
            redirect_to root_path
        end
      else
          session[:user_id] = @user.id
          flash[:success] = "Logged in successfully"
          redirect_to root_path
      end
    else
        flash[:error] = "Could not log in"
        redirect_to root_path
    end
  end

  def logout
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out"
    redirect_to root_path
  end
end
