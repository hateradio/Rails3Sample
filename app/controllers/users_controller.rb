class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def index
    @users = User.paginate page: params[:page]
  end

  def show
    @user = User.find params[:id]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    begin
      @user.save!
      flash[:success] = "Welcome to the Sample App!"
      sign_in @user
      redirect_to @user
    rescue ActiveRecord::RecordInvalid
      render :'users/new'
    end
  end

  def edit; end

  def update
    begin
      @user.update_attributes! params[:user]
      flash[:success] = 'Profile updated'
      sign_in @user
      redirect_to @user
    rescue ActiveRecord::RecordInvalid
      render :'users/edit'
    end
  end

  def destroy
    show().destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: 'Please sign in.'
    end
  end

  def correct_user
    show
    redirect_to root_path unless current_user?(@user)
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
