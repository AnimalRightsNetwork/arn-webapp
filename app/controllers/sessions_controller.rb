class SessionsController < ApplicationController
  def new
    if logged_in?
      flash[:warning] = t('.already_logged_in')
      redirect_to root_url
    end
  end

  # Log in
  def create
    user = User.find_by(email: session_params[:email].downcase)
    if user && user.authenticate(session_params[:password])
      if user.activated?
        log_in user
        flash[:success] = t('.success')
        redirect_to root_url
      else
        flash.now[:error] = t('.not_activated')
        render :new
      end
    else
      flash.now[:error] = t('.failure')
      render :new
    end
  end

  # Log out
  def destroy
    flash[:success] = t('.success') if log_out
    redirect_to root_url
  end

  ###########
  # Helpers #
  ###########
  private
    def session_params
      params.require(:session).permit(:email, :password)
    end
end
