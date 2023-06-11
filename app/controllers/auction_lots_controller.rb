class AuctionLotsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :approve, :expired, :conquered]
  before_action :require_admin, only: [:new, :create, :approve, :expired, :cancel, :close]
  before_action :require_creator, only: [:add, :remove]
  before_action :require_user_common, only: [:bid, :conquered]


  def index
    @lots_running = AuctionLot.running
    @lots_scheduled = AuctionLot.scheduled
  end

  def show
    @lot = AuctionLot.find(params[:id])

    @auction_item_opts = AuctionItem.where(auction_lot: nil).collect {|item|
      [item.full_description, item.id]
    }
  end

  def new
    @lot = AuctionLot.new
  end

  def create
    lot_params = params.require(:auction_lot).permit(
      :code, :start_date, :end_date, :start_price, :min_bid_diff
    )

    @lot = AuctionLot.new(lot_params)
    @lot.creator_user = current_user

    if @lot.save
      return redirect_to @lot, notice: 'Lote registrado com sucesso!'
    end

    render :new
  end

  def add
    lot = AuctionLot.find(params[:id])
    item = AuctionItem.find(params[:item_id])

    lot.auction_items << item

    redirect_to lot
  end

  def remove
    lot = AuctionLot.find(params[:id])
    item = AuctionItem.find(params[:item_id])

    item.update(auction_lot: nil)

    redirect_to lot
  end

  def approve
    lot = AuctionLot.find(params[:id])

    lot.evaluator_user = current_user
    lot.status = :approved
    
    if lot.save
      return redirect_to lot, notice: 'Lote aprovado com sucesso!'
    end
    
    redirect_to root_path, alert: "Ação não permitida!"
  end

  def cancel
    lot = AuctionLot.find(params[:id])

    unless lot.winner_bidder
      lot.evaluator_user = current_user
      lot.status = :canceled

      if lot.save
        return redirect_to auction_lot_path(lot), notice: 'Lote cancelado com sucesso!'
      end

      return redirect_to root_path, alert: 'Ação não permitida!'
    end

    redirect_to auction_lot_path(lot), alert: 'Este lote tem ofertas, deve ser encerrado!'
  end

  def close
    lot = AuctionLot.find(params[:id])

    if lot.winner_bidder
      lot.evaluator_user = current_user
      lot.status = :closed

      if lot.save
        return redirect_to auction_lot_path(lot), notice: 'Lote encerrado com sucesso!'
      end

      return redirect_to root_path, alert: 'Ação não pemitida!'
    end

    redirect_to auction_lot_path(lot), notice: 'Este lote não tem ofertas, deve ser cancelado!'
  end

  def expired
    @expired_lots = AuctionLot.expired
  end

  def conquered
    @conquered_lots = current_user.auction_lots.where(status: :closed)
  end


  private

  def require_creator
    lot = AuctionLot.find(params[:id])

    if lot.creator_user != current_user
      flash[:alert] = "Ação não permitida!"
      redirect_to root_path
    end
  end

  def require_user_common
    if user_signed_in? && current_user.admin?
      redirect_to(root_path, notice: "Ação não permitida!")
    end
  end
end
