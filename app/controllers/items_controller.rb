class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    if params[:user_id]
      user = User.find(params[:user_id])
      item = user.items.find(params[:id])
    else
      item = Item.find(params[:id])
    end
    render json: item, include: :user
  end

  def create
    if params[:user_id]
      user = User.find(params[:user_id])
      item = user.items.create(items_params)
    else
      item = Item.create(items_params)
    end
    render json: item, include: :user, status: :created
  end

  private

  def items_params
    params.permit(:name, :description, :price)
  end

  def not_found_response
    render json: { error: 'User not found' }, status: :not_found
  end
end