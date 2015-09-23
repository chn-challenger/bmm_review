require 'sinatra/base'
require_relative 'models/link.rb'
require_relative '../data_mapper_setup'

class BookmarkManager < Sinatra::Base
  set :views, proc{File.join(root, '..' , 'views')}

  get '/' do
    redirect '/links'
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
    erb :'links/new'
  end

  post '/links' do
    link = Link.create(url: params[:url],title: params[:title])
    unless params[:tags] == '' || params[:tags].nil?
      params[:tags].split(' ').each do |tag_name|
        link.tags << Tag.create(name: tag_name)
      end
      link.save
    end
    redirect '/links'
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

end
