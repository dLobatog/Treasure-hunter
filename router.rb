#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'slim'
require 'vacuum'
require 'json'

before do 
  @req = Vacuum.new :product_advertising

  @req.configure do |config|
    config.key    = ''
    config.secret = ''
    config.tag    = ''
  end
end

get '/' do
  list_of_products('Jambox')
  slim :product
end                             

get '/help' do
  slim :help
end 

get '/product/' do               
  list_of_products('Kindle')
  slim :product
end

get '/product/:search_query' do
  list_of_products(params[:search_query])
  slim :product
end

get '/topsellers/:search_query' do     
  top_seller_list(params[:search_query])
  slim :top_seller
end

def item_lookup(item_id)
  response_group = %w{ItemAttributes Images OfferFull}

  @req.build 'Operation'                       => 'ItemLookup',
             'ItemId'                          => item_id,
             'ItemSearch.Shared.ResponseGroup' => response_group

  @req.get.find('Item').first
end

def top_seller_list(query)
  response_group = %w{TopSellers}

  @req.build 'Operation'                       => 'BrowseNodeLookup',
             'BrowseNodeId'                    => query,
             'ItemSearch.Shared.ResponseGroup' => response_group

  top_sellers = @req.get.find 'TopItem'

  @titles, @urls, @prices, @product_groups, @backgrounds, @availabilities = [],[],[],[],[],[]

  top_sellers.each do |item|
    @titles         << item['Title']
    @urls           << item['DetailPageURL']
    @product_groups << item['ProductGroup'] unless item['ProductGroup'].nil?
    item             = item_lookup(item['ASIN'])
    @backgrounds    << item['LargeImage']['URL'] unless item['LargeImage'].nil?
  end
   
  
end

def list_of_products(query)
  response_group = %w{ItemAttributes Images OfferFull}
  @req.build 'Operation'                       => 'ItemSearch',
             'ItemSearch.Shared.SearchIndex'   => 'All',
             'ItemSearch.Shared.Keywords'      => query,
             'ItemSearch.Shared.ResponseGroup' => response_group,
             'ItemSearch.1.ItemPage'           => 1,
             'ItemSearch.2.ItemPage'           => 2


  items = @req.get.find 'Item'

  @titles, @urls, @prices, @product_groups, @backgrounds, @availabilities = [],[],[],[],[],[]

  items.each do |item|
    @titles         << item['ItemAttributes']['Title']
    @urls           << item['DetailPageURL']
    @prices         << item['ItemAttributes']['ListPrice']['FormattedPrice'] unless item['ItemAttributes']['ListPrice'].nil?
    @product_groups << item['ItemAttributes']['ProductGroup'] unless item['ItemAttributes']['ProductGroup'].nil?
    @backgrounds    << item['LargeImage']['URL'] unless item['LargeImage'].nil?
    @availabilities << item['Offers']['Offer']['OfferListing']['Availability'] unless (item['Offers'].nil? || item['Offers']['TotalOffers'].to_i.zero?)
  end

  if @titles.nil? or @titles.empty? 
    @titles         = ["Error"]
    @availabilities = ["No"]
    @prices         = ["items match your search"]
    @product_groups = ["Search for another product!"]
  end
   
end
