class PasswordResetsController < ApplicationController

  before_action(:get_user, only: [:edit, :update])
  before_action(:valid_user, only: [:edit, :update])
  before_action(:check_expiration, only: [:edit, :update])

  def new; end

  def create
    email = params[:password_reset][:email].downcase
    @user = User.find_by(email: email)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "The password reset instructions were sent to '#{email}'."
      redirect_to(root_url)
    else
      flash.now[:danger] = "The email address '#{email}' was not found."
      render('new')
    end
  end

  def edit
    @user = User.find_by(email: params[:email])
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, 'Can\'t be empty')
      render('edit')
    elsif @user.update_attributes(user_params)
      log_in(@user)
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = 'Your password has been reset!'
      redirect_to(@user)
    else
      render('edit')
    end
  end

private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
      flash[:warning] = 'That password reset link is invalid or has expired.'
      redirect_to(root_url)
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = 'That password reset link has expired.'
      redirect_to(new_password_reset_url)
    end
  end

end