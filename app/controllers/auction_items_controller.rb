class AuctionItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :require_admin, only: [:new, :create]
  before_action :set_categories, only: [:new, :create]


  def show
    @item = AuctionItem.find(params[:id])
  end

  def new
    @item = AuctionItem.new
  end

  def create
    item_params = params.require(:auction_item).permit(
      :name, :description, :photo, :weight, :width, :height,
      :depth, :category_item_id
    )

    @item = AuctionItem.new(item_params)

    if @item.save
      flash[:notice] = 'Item registrado com sucesso!'
      return redirect_to auction_item_path(@item)
    end

    flash.now[:notice] = 'Alguns campos estão incorretos, revise-os.'
    render :new
  end

  private

  def set_categories
    @categories = CategoryItem.all
  end
end
