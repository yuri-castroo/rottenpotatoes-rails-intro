class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.distinct.pluck(:rating)
    # @all_ratings = Movie.all_ratings
    @movies = Movie.all
    @sort_by = params[:sort_by]
    @movies = @movies.order(@sort_by)
    
    if !params[:ratings].nil?
       # Setting the filtering option:
      if(params[:ratings])
        @ratings_filter = params[:ratings].keys
        session[:ratings] = params[:ratings]
      elsif(session[:ratings])
        @ratings_filter = session[:ratings].keys
      else
        @ratings_filter = Movie.all_ratings
      end
    end

    # @movies = Movie.order(@sort_by)
    @movies = Movie.all.where(rating: @ratings_filter).order(@sort_by)
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
