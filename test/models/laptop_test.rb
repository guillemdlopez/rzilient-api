require 'test_helper'

class LaptopTest < ActiveSupport::TestCase

  test "should not save an emtpy Laptop" do
    laptop = Laptop.new()

    assert_not laptop.save
  end

  test "should not save a Laptop without a name" do
    laptop = Laptop.new(code: 'AP1')

    assert_not laptop.save
  end

  test "should not save a Laptop without a price" do
    laptop = Laptop.new(code: 'AP1', name: 'Macbook Pro 13')

    assert_not laptop.save
  end

  test "should not save a Laptop with a price equal to 0" do
    laptop = Laptop.new(code: 'AP1', name: 'Macbook Pro 13', price: 0)

    assert_not laptop.save
  end

  test "should not save a Laptop with an unformatted code" do
    laptop = Laptop.new(code: 'AAA', name: 'Macbook Pro 13', price: 150)

    assert_not laptop.save
  end

  test "should not save duplicated laptops" do
    laptop = Laptop.new(code: 'AP1', name: 'Macbook Pro 15', price: 1000)
    laptop_2 = Laptop.new(code: 'AP1', name: 'Macbook Pro 15', price: 1000)

    assert laptop.save
    assert_not laptop_2.save
  end
end
