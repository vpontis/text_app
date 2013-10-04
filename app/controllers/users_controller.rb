class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def index
    @users = User.all.order("created_at desc")
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the texts app!"
      redirect_to @user
    else
      flash[:error] = "There was an error creating your account"
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
