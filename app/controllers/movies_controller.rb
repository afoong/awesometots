class MoviesController < ApplicationController
  @all_ratings
  @last_ratings
  @isSortedOn
  @orderStr

  def initialize
    super()
    @all_ratings = Movie.allRatings
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # p params
    # @movies = Movie.all
    session.clear

    if params.has_key?("sortBy")
      @orderStr = "#{params[:sortBy]}"
      session[:sortBy] = @isSortedOn = params[:sortBy]
    else
        if session.has_key?("sortBy") 
          @orderStr = "#{session[:sortBy]}"
          @isSortedOn = session[:sortBy]
        else
          @orderStr = @orderStr
          @isSortedOn = @isSortedOn
        end
    end

    if params.has_key?("ratings")
      @ratings = params[:ratings].keys
      @last_ratings = params[:ratings]
      session[:ratings] = @last_ratings = params[:ratings]
    else
        if session.has_key?("ratings") 
          @ratings = session[:ratings].keys
          @last_ratings = session[:ratings]
          @last_ratings = session[:ratings]
        else
          @ratings = @all_ratings
          @last_ratings = Hash.new
        end
    end

    @movies = Movie.order("#{@orderStr}").find(:all, 
      :conditions => ["rating in (?)", @ratings])

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
