class Admin::GenresController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @genre = Genre.new
    @genres = Genre.all
  end

  def create
    @genre = Genre.new(params_genre)
    @genre.save
    redirect_to admin_genres_path
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
    Genre.find(params[:id]).update(params_genre)
    redirect_to admin_genres_path
  end

  private

  def params_genre
    params.require(:genre).permit(:name)
  end
end
