class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all
    render json: articles
  end

  def show
    session[:page_views] ||= 0
    session[:page_views] += 1

    if session[:page_views] <= 3
      article = Article.find(params[:id])
      render json: article
    elsif session[:page_views] > 3
      render json: { error: 'Maximum page views reached. Please subscribe to continue.' }, status: :unauthorized
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
