class Api::V1::CheckoutsController < ApplicationController
  def checkout
    codes = params[:ids]
    
    if !codes.present? || codes.empty?
      render json: { message: "Something went wrong... Please try it again", status: :unprocessable_entity }
    end

    if codes.present?
      laptops = Laptop.find_laptops(params[:ids])

      price = basic_price(laptops)
      
      # calculate payment methods
      if two_lenovos?(codes)
        total_price = buy_one_get_one_free(price)
      elsif two_or_more_macbooks?(codes)
        total_price = macbook_discount(price)
      else
        total_price = price
      end

      render json: {
        message: 'This is your bill. Come back soon!',
        cart: laptops,
        total_price: "The total amount to pay is #{total_price.ceil}€",
        status: :success 
      }
    end
  end

  private

  def two_lenovos?(codes)
    codes.count('LN1') >= 2
  end

  def two_or_more_macbooks?(codes)
    codes.count('AP1') >= 2
  end

  def macbook_discount(price)
    price * 0.9
  end

  def buy_one_get_one_free(price)
    price - 41
  end

  def basic_price(laptops)
    price = 0

    laptops.each do |laptop|
      price += laptop.price.to_i
    end

    return price
  end
end
