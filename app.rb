#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'active_record'
require 'sqlite3'


set :database, {adapter: "sqlite3", database: "pizzashop.sqlite3"}


class Product < ActiveRecord::Base
end

class Order < ActiveRecord::Base
end

get '/' do
  erb :index
end

get '/products' do
  @products = Product.all
  erb :products
end

# post '/products' do
#   :cart
# end

get '/cart' do
  erb :cart
end

post '/cart' do

  @orders_input = params[:orders]

  @items = parse_orders_input @orders_input

  # если корзина пустая
  if @items.length == 0
    return erb "В корзине нет товаров"
  end

  # выводим список продуктов в корзине
  @items.each do |item|
    # id, cnt
    item[0] = Product.find(item[0])
  end

  erb :cart
end

# Parse orders line:
def parse_orders_input orders_input

  s1 = @orders_input.split(/,/)

  arr = []

  s1.each do |x|
    s2 = x.split(/\=/)
    s3 = s2[0].split(/_/)

    id = s3[1]
    cnt = s2[1]

    arr2 = [id, cnt]
    arr.push arr2
  end

  return arr
end

post '/place_order' do
  @o = Order.create params[:order]

  erb :order_placed
end

get '/manager' do
  @order = Order.all
  erb :manager
end

post '/delete_order' do
	erb :delete
end	