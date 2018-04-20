class UsersController < ApplicationController

  # Hooks.

  before_action(
    :logged_in_user,
    only: [
      :index,
      :edit,
      :update])

  before_action(
    :correct_user,
    only: [
      :edit,
      :update])

  before_action(
    :admin_user,
    only: [
      :destroy
    ]
  )

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def new
    @user = User.new
    @form_action = signup_path
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to(root_url) and return unless @user.activated?
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Thanks for registering, #{@user.name}! Please activate your account via the link sent to '#{@user.email}'."
      redirect_to(root_url)
    else
      render('new')
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Your profile was updated."
      redirect_to(@user)
    else
      render('edit')
    end
  end

  def destroy
    user_to_delete = User.find(params[:id])
    user_to_delete.destroy
    flash[:success] = "The user '#{user_to_delete.name}' was deleted."
    redirect_to(users_url)
  end

private

  def user_params
    return params
      .require(:user)
      .permit(
        :name,
        :email,
        :password,
        :password_confirmation)
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user&.admin?
  end

end
