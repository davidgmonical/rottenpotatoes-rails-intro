class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @all_ratings = Movie.all_ratings
  
    if (params[:ratings])
      @checked_ratings = Hash[@all_ratings.map{|r| [r, params[:ratings].keys.include?(r)]}]
    else
      @checked_ratings = Hash[@all_ratings.map{|r| [r, @all_ratings.include?(r)]}]
    end

    @movies = Movie.all

    if (params[:ratings])

      @movies = Movie.with_ratings(params[:ratings].keys)

    end

    if (params[:sort] == "release_date")
      @movies = @movies.all.sort_by{|movie| movie[:release_date]}
    elsif (params[:sort] == "title")
      @movies = @movies.all.sort_by{|movie| movie[:title]}
    else
      @movies = @movies.all
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
