class SessionsController < ApplicationController
  def new
  end

  def create
    user = find_user
    if user
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email and/or password'
      render :'sessions/new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

  def find_user
    User.find_by_email(params[:email].downcase).try(:authenticate, params[:password])
  end
end
