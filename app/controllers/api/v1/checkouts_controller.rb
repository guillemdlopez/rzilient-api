class Api::V1::CheckoutsController < ApplicationController
  def checkout
    @codes = params[:ids]

    if @codes.present?
      @laptops = Laptop.find_laptops(params[:ids])

      if @laptops.empty?
        render json: { message: 'Something went wrong!' }
      else
        @price = basic_price(@laptops)

        discount_logic()
        
        render json: {
          message: 'This is your bill. Come back soon!',
          cart: @laptops,
          total_price: "The total amount to pay is #{@price.ceil}€",
          status: :success 
        }
      end
    else
      render json: { message: 'Your cart is empty!' } 
    end
  end

  private

  def discount_logic
    if at_least_two_lenovos?(@codes) && two_or_more_macbooks?(@codes)
      @price -= macbook_discount(@laptops, @price)
      @price -= buy_one_get_one_free(@laptops, @price)
    elsif at_least_two_lenovos?(@codes)
      @price -= buy_one_get_one_free(@laptops, @price)
    elsif two_or_more_macbooks?(@codes)
      @price -= macbook_discount(@laptops, @price)
    end
  end

  def at_least_two_lenovos?(codes)
    @codes.count('LN1') >= 2
  end

  def two_or_more_macbooks?(codes)
    @codes.count('AP1') >= 2
  end

  def macbook_discount(laptops, price)
    macs = @laptops.select {|lap| lap.code == "AP1"}

    ((macs.length * 60) * 10) / 100  
  end

  def buy_one_get_one_free(laptops, price)
    lns = @laptops.select {|lap| lap.code == "LN1"}

    (lns.length.to_f / 2).floor * 41
  end

  def basic_price(laptops)
    @price = 0

    @laptops.each do |laptop|
      @price += laptop.price.to_i
    end

    return @price
  end
end
