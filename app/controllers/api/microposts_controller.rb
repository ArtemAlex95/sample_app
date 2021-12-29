class Api::MicropostsController < ApplicationController
  def index
    @microposts = Micropost.all
    render json: MicropostSerializer.new(@microposts).serialized_json
  end

  def show
    @micropost = Micropost.find(params[:id])
    render json: MicropostSerializer.new(@micropost).serialized_json
  end
end
