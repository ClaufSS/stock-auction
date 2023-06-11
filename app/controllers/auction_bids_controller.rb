class AuctionBidsController < ApplicationController
  def create
    @lot = AuctionLot.find(params[:auction_lot_id])

    bid = @lot.bids.build(bid: params[:bid], bidder: current_user)

    if bid.save
      return redirect_to auction_lot_path(@lot)
    end
    
    redirect_to auction_lot_path(@lot), notice: 'Valor de lance abaixo de mínimo!'
  end
end
