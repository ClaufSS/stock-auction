class LotsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :require_admin, only: [:new, :create, :approve, :expired, :cancel, :close]
  before_action :require_creator, only: [:add, :remove]
  before_action :require_different_admin, only: [:approve]
  before_action :require_user_common, only: [:bid, :conquered]


  def index
    @lots_running = Lot.running
    @lots_scheduled = Lot.scheduled
  end

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
    lot.approved!
    lot.save

    redirect_to lot, notice: 'Lote aprovado com sucesso!'
  end

  def bid
    lot = Lot.find(params[:id])
    user_offer = params[:offer].to_f

    if lot.running? && (lot.min_offer < user_offer)
      lot.user_player_id = current_user.id
      lot.offer = user_offer
      lot.save!

      return redirect_to lot_path(lot)
    end

    flash[:notice] = "Valor de oferta abaixo de mínimo!"
    redirect_to lot_path(lot)
  end

  def expired
    @expired_lots = Lot.expired
  end

  def cancel
    lot = Lot.find(params[:id])

    unless lot.user_player
      lot.canceled!

      return redirect_to lot_path(lot), notice: 'Lote cancelado com sucesso!'
    end

    redirect_to lot_path(lot), notice: 'Este lote tem ofertas, deve ser encerrado.'
  end

  def close
    lot = Lot.find(params[:id])

    if lot.user_player
      lot.closed!

      return redirect_to lot_path(lot), notice: 'Lote encerrado com sucesso!'
    end

    redirect_to lot_path(lot), notice: 'Este lote não tem ofertas, deve ser cancelado.'
  end

  def conquered
    @conquered_lots = current_user.lots.where(status: :closed)
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

  def require_user_common
    if current_user.admin?
      redirect_to(root_path, notice: "Ação não permitida!")
    end
  end
end
