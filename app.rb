#encoding: utf-8
require 'rubygems'
require 'date'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'active_record'
require 'sqlite3'
require 'rest-client'
require 'json'
require 'redis-sinatra'


set :database, {adapter: "sqlite3", database: "pizzashop.sqlite3"}


class Product < ActiveRecord::Base
end

class Order < ActiveRecord::Base
end


before do
  cache_control course_valut, :must_revalidate, :max_age => 60000
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


$CACHE = nil
$CACHE_EXPIRED = nil

def get_course_from_privat
  puts "================= PRIVAT ==============================="
  data = RestClient.get("https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=5")
  ower = JSON.parse(data.body)

  $CACHE = ower
  $CACHE_EXPIRED = DateTime.now + 1.minutes

  return ower
end

# курс валют приват 24
def course_valut 
  #puts $CACHE
  #puts $CACHE_EXPIRED
  
  if $CACHE.nil?
    ower = get_course_from_privat
  elsif $CACHE_EXPIRED < DateTime.now
    ower = get_course_from_privat
  else
    ower = $CACHE
  end

  course_usd = ower[0]
  course_eur = ower[1]
# usd
  @usd =  course_usd["ccy"]   
  @usd_price_buy = course_usd["buy"].to_f
  @usd_price_sale = course_usd["sale"].to_f
#eur
   @eur =  course_eur["ccy"]   
  @eur_price_buy = course_eur["buy"].to_f
  @eur_price_sale = course_eur["sale"].to_f
   

end
