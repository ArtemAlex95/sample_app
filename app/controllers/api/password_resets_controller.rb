class Api::PasswordResetsController < ApplicationController
  def index
    @resets = Micropost.all
    render json: @resets
  end

  def show
    @reset = Micropost.find(params[:id])
    render json: @reset
  end
end
