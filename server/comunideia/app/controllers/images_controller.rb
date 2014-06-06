# encoding: UTF-8
class ImagesController < ApplicationController

FLICKER_API_KEY=''
FLICKER_SHARED_SECRET=''

FlickRaw.api_key=FLICKER_API_KEY
FlickRaw.shared_secret=FLICKER_SHARED_SECRET

  def get_token_oauth

    @callback_token_url = request.base_url.to_s + '/callback_token'
    flickr = FlickRaw::Flickr.new

    token = flickr.get_request_token(:oauth_callback => URI.escape(@callback_token_url))

    @auth_url = flickr.get_authorize_url(token['oauth_token'], :perms => 'write', :perms => 'delete')

    session[:auth_url] = @auth_url
    session[:token_oauth_token] = token["oauth_token"]
    session[:token_oauth_token_secret] = token["oauth_token_secret"]

    redirect_to @auth_url

  end

  def callback_token

    raw_token = flickr.get_access_token(session[:token_oauth_token], session[:token_oauth_token_secret], params[:oauth_verifier])

    flash[:success] = "Flickr app autorizado."
    redirect_to root_path

  end

end
