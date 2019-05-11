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

get '/' do
	@products = Product.all
	erb :index
end


get '/about' do
	erb :about
end	

post '/cart' do
	erb :cart
end	