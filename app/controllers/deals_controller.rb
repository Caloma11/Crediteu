class DealsController < ApplicationController

  def index
    @deals = policy_scope(Deal).all
  end

  def show
    @deal = Deal.find(params[:id])
    @transaction = Transaction.new
    authorize @deal
    @company = @deal.company

    if @company.latitude && @company.longitude
      @markers = [@company].map do |company|
        {
          lat: company.latitude,
          lng: company.longitude,
        }
      end
    end
  end

  def new
    @deal = Deal.new
    authorize @deal
  end

  def create
    @deal = Deal.new(deal_params)
    @deal.company = current_user.company
    authorize @deal
    if @deal.save
      redirect_to '/deals'
    else
      puts @deal.errors.full_messages
      render 'new'
    end
  end

  def edit
    @deal = Deal.find(params[:id])
    authorize @deal
  end

  def update
    @deal = Deal.find(params[:id])
    @deal.update(deal_params)
    authorize @deal

    redirect_to deals_path
  end

  def destroy
    authorize @deal
  end


private

   def deal_params
    params.require(:deal).permit(:start_date, :end_date, :amount, :rate_per_annum, :credit_rating,
      :status)
  end

end
