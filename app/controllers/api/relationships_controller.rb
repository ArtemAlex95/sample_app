class Api::RelationshipsController < ApplicationController
  def index
    @relationships = Relationship.all
    render json: @relationships
  end

  def show
    @relationship = Relationship.find(params[:id])
    render json: @relationship
  end
end
