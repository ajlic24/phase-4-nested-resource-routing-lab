class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if params[:user_id]
      items = find_user
      render json: items.items, status: :ok
    else
      items = Item.all
      render json: items, include: :user
    end
  end

  def show
    item = Item.find(params[:id])
    render json: item, status: :ok
  end

  def create
    user = find_user
    created = user.items.create(items_params)
    render json: created, status: :created
  end

  private 

  def items_params
    params.permit(:name, :description, :price)
  end

  def find_user
    User.find(params[:user_id])
  end

  def render_not_found_response
    render json: {error: 'user not found'}, status: :not_found
  end
end
