# encoding: UTF-8
class ImagesController < ApplicationController

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

  def upload_images
  	
    idea = Idea.find(params[:idea_id])

    i = 0
    params[:images].each do |key, value|
      if i < Idea::MAX_IMAGES

        begin
          login = flickr.test.login
          
          uploaded_io = value
          image_name = uploaded_io.original_filename.blank? ? DateTime.now.strftime('%Y%m%d%H%M%S%L') : uploaded_io.original_filename

          pic_path = Rails.root.join('public', 'uploads_tmp', image_name)
          File.open(pic_path, 'wb') do |file|
            file.write(uploaded_io.read)
          end

          # You need to be authentified to do that
          photo_id = flickr.upload_photo pic_path, :title => image_name

          info = flickr.photos.getInfo(:photo_id => photo_id)


          File.delete(pic_path)

          photo_url = FlickRaw.url_b(info).to_s
          idea.img_pgs[i] = photo_url

        rescue FlickRaw::OAuthClient::FailedResponse => e
          flash[:error] = "Ocorreu um erro ao carregar sua imagem. Você pode enviar novamente?"
        end

      end

      i += 1

    end

    idea.current_step = 0
    idea.save
      
    redirect_to root_path #render 'idea-form'
  end

end
