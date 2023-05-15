class LotsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :require_admin, only: [:new, :create]
  before_action :require_creator, only: [:add, :remove]
  before_action :require_different_admin, only: [:approve]


  def show
    @lot = Lot.find(params[:id])
    @auction_item_opts = AuctionItem.where(lot: nil).collect {|item|
      [item.full_description, item.id]
    }
  end

  def new
    @lot = Lot.new
  end

  def create
    lot_params = params.require(:lot).permit(
      :code, :start_date, :end_date, :start_price, :min_bid
    )

    @lot = Lot.new(lot_params)
    @lot.register_user = current_user

    if @lot.save
      return redirect_to @lot, notice: 'Lote registrado com sucesso.'
    end

    render :new
  end

  def add
    lot = Lot.find(params[:id])
    item = AuctionItem.find(params[:item_id])

    lot.auction_items << item

    redirect_to lot
  end

  def remove
    lot = Lot.find(params[:id])
    item = AuctionItem.find(params[:item_id])

    item.update(lot: nil)

    redirect_to lot
  end

  def approve
    lot = Lot.find(params[:id])

    lot.approver_user = current_user
    lot.running!
    lot.save

    redirect_to lot, notice: 'Lote aprovado com sucesso!'
  end

  private

  def require_different_admin
    lot = Lot.find(params[:id])

    if lot.register_user == current_user
      flash[:alert] = "Ação não permitida!"
      redirect_to root_path
    end
  end

  def require_creator
    lot = Lot.find(params[:id])

    if lot.register_user != current_user
      flash[:alert] = "Ação não permitida!"
      redirect_to root_path
    end
  end
end
