class Api::V1::CheckoutsController < ApplicationController
  def checkout
    codes = params[:ids]

    if codes.present?
      laptops = Laptop.find_laptops(params[:ids])

      price = basic_price(laptops)
      
      # calculate payment methods
      if two_lenovos?(codes)
        total_price = buy_one_get_one_free(codes, price)
      elsif two_or_more_macbooks?(codes)
        total_price = macbook_discount(codes, price)
      else
        total_price = price
      end

      if laptops.empty?
        render json: { message: 'Something went wrong!' }
      else
        render json: {
          message: 'This is your bill. Come back soon!',
          cart: laptops,
          total_price: "The total amount to pay is #{total_price.ceil}€",
          status: :success 
        }
      end
    else
      render json: { message: 'Your cart is empty!' } 
    end
  end

  private

  def two_lenovos?(codes)
    codes.count('LN1') >= 2
  end

  def two_or_more_macbooks?(codes)
    codes.count('AP1') >= 2
  end

  def macbook_discount(codes, price)
    macs = codes.select {|lap| lap == "AP1"}
    price = (macs.length * 60) * 0.9  
  end

  def buy_one_get_one_free(codes, price)
      lns = codes.select {|lap| lap == "LN1"}

      price -= (lns.length.to_f / 2).floor * 41
  end

  def basic_price(laptops)
    price = 0

    laptops.each do |laptop|
      price += laptop.price.to_i
    end

    return price
  end
end
