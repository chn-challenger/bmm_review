require 'sinatra/base'
require 'sinatra/flash'
require_relative 'models/link.rb'
require_relative '../data_mapper_setup'

class BookmarkManager < Sinatra::Base
  set :views, proc{File.join(root, '..' , 'views')}
  enable :sessions
  set :session_secret, 'super secret'
  register Sinatra::Flash

  helpers do
    def current_user
        User.get(session[:user_id])
    end
  end

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

  get '/users/new' do
    @user = User.new
    erb :'users/new'
  end

  post '/users' do
    if params[:email] == '' || params[:email].nil?
      flash.now[:notice] = "Must enter an email address"
      erb :'users/new'
    else
      @user = User.new(email: params[:email],
                  password: params[:password],
                  password_confirmation: params[:password_confirmation])
      if @user.save
        session[:user_id] = @user.id
        redirect to('/links')
      else
        flash.now[:notice] = "Password and confirmation password do not match"
        erb :'users/new'
      end
    end
  end

end
