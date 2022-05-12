class Api::TracksController < ApiController
  def index
    @tracks = current_scope.order_by_popular.page(params[:page])
    set_pagination_header @tracks
    fresh_when @tracks
  end

  def show
    @track = Track.find(params[:id])
    fresh_when @track
  end
end
