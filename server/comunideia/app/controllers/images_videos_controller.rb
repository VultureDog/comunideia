# encoding: UTF-8
class ImagesVideosController < ApplicationController

API_KEY=''
SHARED_SECRET=''

FlickRaw.api_key=API_KEY
FlickRaw.shared_secret=SHARED_SECRET

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

  def upload_image
  	
  	begin
      login = flickr.test.login
      
      uploaded_io = params[:image]
      image_name = uploaded_io.original_filename.blank? ? DateTime.now.strftime('%Y%m%d%H%M%S%L') : uploaded_io.original_filename

      pic_path = Rails.root.join('public', 'uploads_tmp', image_name)
      File.open(pic_path, 'wb') do |file|
        file.write(uploaded_io.read)
      end

      # You need to be authentified to do that
      flickr.upload_photo pic_path, :title => image_name

      File.delete(pic_path)

      flash[:success] = "Imagem enviada."
      redirect_to root_path #render 'idea-form'

    rescue FlickRaw::OAuthClient::FailedResponse => e
      flash[:error] = "Ocorreu um erro ao carregar sua imagem. Você pode enviar novamente?"
      redirect_to root_path #render 'idea-form'
    end
  end

end
