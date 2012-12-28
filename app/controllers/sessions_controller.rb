class SessionsController < ApplicationController
  def new
  end

  def create
    user = find_user
    if user
      sign_in user
      redirect_to user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

  def find_user
    User.find_by_email(params[:session][:email].downcase).try(:authenticate, params[:session][:password])
  end
end
