class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  before_filter :has_signed_in,  only: [:new, :create]

  def index
    @users = User.paginate page: params[:page]
  end

  def show
    get_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    begin
      @user.save!
      flash[:success] = 'Welcome to the Sample App!'
      sign_in @user
      redirect_to @user
    rescue ActiveRecord::RecordInvalid
      render :'users/new'
    end
  end

  def edit
    get_user
  end

  def update
    get_user
    if @user.update_attributes(params[:user])
      flash[:success] = 'Profile updated'
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
    #begin
    #  @user.update_attributes! params[:user]
    #  flash[:success] = 'Profile updated'
    #  sign_in @user
    #  redirect_to @user
    #rescue ActiveRecord::RecordInvalid
    #  render :'users/edit'
    #end
  end

  def destroy
    get_user.destroy
    flash[:success] = "#{@user.name} was removed."
    redirect_to users_url
  end

  private

  def get_user
    @user = User.find params[:id]
  end

  def no_admin_self_destroy
    get_user
    if current_user?(@user)
      flash[:notice] = 'You cannot delete yourself.'
      redirect_to users_url
    end
  end

  def has_signed_in
    redirect_to root_path if signed_in?
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: 'Please sign in.'
    end
  end

  def correct_user
    get_user
    redirect_to root_path unless current_user? @user
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
    no_admin_self_destroy
  end
end
