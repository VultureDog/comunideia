# encoding: UTF-8
class IdeasController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  before_action :set_start_step,   only: [:edit, :update]
  before_action :_is_financial_idea?,   only: [:edit, :update]

  def index
    @ideas = Idea.paginate(page: params[:page])
    
    @ideas_COMUNIDEIA_EM_ACAO = Idea.find(:all, :conditions => ["status = ?", Idea::COMUNIDEIA_EM_ACAO])
    @ideas_COMUNIDEIA_EM_FINANCIAMENTO = Idea.find(:all, :conditions => ["status = ?", Idea::COMUNIDEIA_EM_FINANCIAMENTO])

    @index_proj_type = params[:index_proj_type]
  end

  def new
    @idea = params.has_key?(:idea) ? current_user.ideas.new(idea_params).start : current_user.ideas.new.start
    
  end

  def show
    idea_id = params.has_key?(:id) ? params[:id] : random_idea_id
    @idea = Idea.find(idea_id)

    @idea_content_paragraphs = @idea.idea_content.split("\r\n", 6)

    @img_pgs = []
    @img_pgs[0] = @idea.img_pg_1 unless @idea.img_pg_1.nil?
    @img_pgs[1] = @idea.img_pg_2 unless @idea.img_pg_2.nil?
    @img_pgs[2] = @idea.img_pg_3 unless @idea.img_pg_3.nil?
    @img_pgs[3] = @idea.img_pg_4 unless @idea.img_pg_4.nil?
    #@img_pgs[4] = @idea.img_pg_5 unless @idea.img_pg_5.nil?

    @idea_user = User.find(@idea.user_id)

    @recompenses = @idea.recompenses
    @is_financial_idea = is_financial_idea?
      
    if @is_financial_idea
      @fin_value_input = @recompenses.first.financial_value.to_i
      @investment = Investment.new(recompense_id: @recompenses.first.id)
      @recompense = @recompenses.first
 
       # chamar comunidea_investors apenas pra renderizar a aba de investidores
      @idea_investors = comunidea_investors

    end

    @tab_address = params.has_key?(:tab_address) ? params[:tab_address] : nil
  end

  def create
    @user = current_user
    @idea = current_user.ideas.new(idea_params).start
    @idea.financial_value_sum_accumulated = 0;
    
    @feed_items = current_user.feed.paginate(page: params[:page])

    @is_financial_idea = false
    if is_financial_idea?
      @is_financial_idea = is_financial_idea?
      @idea.createRecompenses
    end

    if @idea.valid_and_set_steps && @idea.save
      @idea.step_forward

      recompenses = @idea.recompenses
#      if @is_financial_idea
#        recompenses.build.start
#      end
    else
      flash[:error] = "Ocorreu um erro, tente criar novamente."
    end

    render 'new'
  end

  def edit
  end
  
  def update
    if params.has_key?(:images)
      i = @idea.img_pgs.count
      params[:images].each do |key, value|
        if i < Idea::MAX_IMAGES

          begin
            login = flickr.test.login
            
            uploaded_io = value
            image_name = uploaded_io.original_filename.blank? ? DateTime.now.strftime('%Y%m%d%H%M%S%L') : uploaded_io.original_filename

            arq_img = File.open(value.tempfile, 'r')

            # You need to be authentified to do that
            photo_id = flickr.upload_photo arq_img, :title => image_name

            info = flickr.photos.getInfo(:photo_id => photo_id)


            photo_url = FlickRaw.url_b(info).to_s
            @idea.img_pgs[i] = photo_url

          rescue FlickRaw::OAuthClient::FailedResponse => e
            flash[:error] = "Ocorreu um erro ao carregar sua imagem. Você pode enviar novamente?"
          end

        end

        i += 1

      end
    end

    if params.has_key?(:video)
      video_params = {title: @idea.name, description: 'desc.'}

      @video = Video.create(video_params)
      video_url = ""

      if @video
        @upload_info = Video.token_form(video_params, new_idea_url)

        arq_vid = File.open(params[:video].tempfile, 'r')

        vid_info = Video.yt_session.video_upload(arq_vid, :title => video_params[:title],:description => video_params[:description], :category => 'People',:keywords => %w[cool blah test])

        video_url = vid_info.player_url
        Video.delete_video(@video)
      end

      @idea.video = video_url
    end

    

    if @is_financial_idea
      @idea.recompenses.clear
    end

    if @idea.img_card.nil?
      @idea.img_card = Idea::THUMBNAIL_IMG_SAMPLE
    end

    if !@idea.save
      flash[:error] = Idea::IDEA_SAVE_ERROR
    end

    @idea.current_step = idea_params[:current_step].to_i
 
    parameters = idea_params
    parameters[:date_start] = DateTime.now + (Time.now.hour + 1).hour
    parameters[:date_end] = DateTime.now + idea_params[:idea_end_date_input].to_i + (Time.now.hour + 1).hour
    #parameters.delete :idea_end_date_input
 
    if @idea.update_attributes(parameters)
      flash[:success] = "Dados atualizados."

      if (@idea.current_step.to_i == 1) || (@idea.current_step.to_i == 2)
        redirect_to idea_path(@idea)
      else
        redirect_to edit_idea_path(@idea, :all => 1)
      end
    else
      render 'edit'
    end
  end

  def destroy
    @idea.destroy
    redirect_to current_user
  end

  protected
    def collection
      @videos ||= end_of_association_chain.completes
    end

  private

    def set_start_step
      @idea.start
    end

    def _is_financial_idea?
      @is_financial_idea = is_financial_idea?
    end

    def is_financial_idea?
       @idea.status == Idea::COMUNIDEIA_EM_FINANCIAMENTO
    end

    def idea_params
      params.require(:idea).permit(:current_step, :name, :status, :summary, :local, :idea_end_date_input, :financial_value, :financial_value_sum_accumulated, :img_card, :video, :img_pg_1, :img_pg_2, :img_pg_3, :img_pg_4, :idea_content, :risks_challenges, :consulting_project, :consulting_creativity, :consulting_financial_structure, :consulting_specific, :recompenses_attributes => [:title, :summary, :quantity, :financial_value, :index_order, :date_delivery, :_destroy] )
    end

    def correct_user
      @idea = current_user.ideas.find(params[:id])
  	rescue
  	  redirect_to root_url
  	end

    def random_idea_id
      Idea.all[0 + Random.rand(Idea.count)].id
    end

    def comunidea_investors
      recompenses_ids = Idea.find(@idea).recompenses.map(&:id)
      investments_ids = Investment.where(recompense_id: recompenses_ids).map(&:user_id).uniq
      User.where(id: investments_ids)
    end

end