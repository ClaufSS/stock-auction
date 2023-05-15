class LotsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :require_admin, only: [:new, :create]


  def show
    @lot = Lot.find(params[:id])
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
end
