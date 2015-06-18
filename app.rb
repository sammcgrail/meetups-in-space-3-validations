require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'

require_relative 'config/application'

Dir['app/**/*.rb'].each { |file| require_relative file }

helpers do
  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id.present?
  end

  def signed_in?
    current_user.present?
  end
end

def set_current_user(user)
  session[:user_id] = user.id
end

def authenticate!
  unless signed_in?
    flash[:notice] = 'You need to sign in if you want to do that!'
    redirect '/'
  end
end

get '/' do
  erb :index
end

get '/auth/github/callback' do
  auth = env['omniauth.auth']

  user = User.find_or_create_from_omniauth(auth)
  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/example_protected_page' do
  authenticate!
end

get '/meetups/:meetup_id' do
  @meetup = Meetup.find(params[:meetup_id])
  @title = @meetup.name
  authenticate!
  erb :show
end

get '/new' do
  erb :form
end

post '/new' do
  meetup = Meetup.create!(params[:meetup])
  MeetupJoin.create!(user_id: current_user.id, meetup_id: meetup.id)
  flash[:notice] = "You have created a space meeting! (And you have been signed up!)"
  redirect "/meetups/#{meetup.id}"
end

post '/join/:meetup_id' do
  meetup = Meetup.find(params[:meetup_id])
  unless meetup.users.include?(current_user)
    MeetupJoin.create!(user_id: current_user.id, meetup_id: params[:meetup_id])
    flash[:notice] = "You have signed up for this meetup!"
    redirect "/meetups/#{params[:meetup_id]}"
  else
    flash[:notice] = "You have ALREADY signed up for this meetup!"
    redirect "/meetups/#{params[:meetup_id]}"
  end
end

post '/leave/:meetup_id' do
  meetup =  Meetup.find(params[:meetup_id])
  MeetupJoin.where(user: current_user, meetup: meetup).destroy_all
  flash[:notice] = "You have left #{meetup.name}!"
  redirect '/'
end

post '/postcomment/:meetup_id' do
  meetup =  Meetup.find(params[:meetup_id])
  unless params[:body] == nil || params[:body] == ""
    Comment.create!(title: params[:title], body: params[:body],
                    user_id: current_user.id,
                    meetup_id: params[:meetup_id]
                    )
    flash[:notice] = "You have left a comment on #{meetup.name}!"
    redirect "/meetups/#{params[:meetup_id]}"
  else
    flash[:notice] = "You need to have a body!"
    redirect "/meetups/#{params[:meetup_id]}"
  end
end
