class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    @user.save
    if @user.has_filtered_errors?
      flash.now[:error] = t('.failure')
      render :new
    else
      unless @user.errors.any?
        UsersMailer.signup(@user, @user.activation_token).deliver_later
      end
      flash[:success] = t('.success')
      redirect_to root_url
    end
  end

  def activation
    User.find(params[:id].downcase)
  end

  def activate
    if User.find(params[:id].downcase).activate(params[:token])
      flash[:success] = t('.success')
      redirect_to login_url
    else
      flash[:error] = t('.failure')
      redirect_to root_url
    end
  end

  ###########
  # Helpers #
  ###########
  private
    # Get new user parameters
    def user_params
      params.require(:user).permit(:display_id, :email, :password, :password_confirmation)
    end
end
