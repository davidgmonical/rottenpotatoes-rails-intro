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

    if (params[:sort] != nil)

      session[:sort] = params[:sort]

    end
    puts params[:ratings]
    puts params[:ratings] != nil

    if (params[:ratings] != nil && !params[:ratings].keys.empty?)
      puts params[:ratings].keys
      puts "IN"
      session[:ratings] = params[:ratings]

    end

    if (params[:ratings] != nil && params[:ratings].keys.empty?)

      flash.keep
      redirect_to movies_path(ratings: session[:ratings], sort: session[:sort])

    end


    @all_ratings = Movie.all_ratings
  
    if (session[:ratings])
      @checked_ratings = Hash[@all_ratings.map{|r| [r, session[:ratings].keys.include?(r)]}]
    else
      @checked_ratings = Hash[@all_ratings.map{|r| [r, @all_ratings.include?(r)]}]
    end

    @movies = Movie.all

    if (session[:ratings])

      @movies = Movie.with_ratings(session[:ratings].keys)

    end

    if (session[:sort] == "release_date")
      @movies = @movies.all.sort_by{|movie| movie[:release_date]}
    elsif (session[:sort] == "title")
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
