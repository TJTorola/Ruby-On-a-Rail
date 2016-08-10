class ApplicationController < ControllerBase
  protect_from_forgery

  def show
    render_content("RAIL!", "text/html")
  end

  def show_cats
    render_content(@params[:cat_id], "text")
  end
end