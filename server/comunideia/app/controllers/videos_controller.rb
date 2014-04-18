class VideosController < InheritedResources::Base

  def save_video
    flash[:error] = "id ::::::::: " + params.to_s
    redirect_to root_path
    @video = Video.find(params[:video_id])
    if params[:status].to_i == 200
      @video.update_attributes(:yt_video_id => params[:id].to_s, :is_complete => true)
      Video.delete_incomplete_videos
    else
      Video.delete_video(@video)
    end
    redirect_to root_path, :notice => "video successfully uploaded"
  end

  protected
    def collection
      @videos ||= end_of_association_chain.completes
    end

    def video_params
      params.require(:video).permit(:title, :description)
    end

end
