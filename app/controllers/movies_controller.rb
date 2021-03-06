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
    #session.clear
    sort_choice= params[:sort] || session[:sort]
    case sort_choice
      when 'title'
        @movies = Movie.order(sort_choice)
        @title_header='hilite'
      when 'release_date'
        @movies = Movie.order(sort_choice)
        @release_date_header='hilite' 
      else
      @movies=Movie.all 
      @selected_ratings=@all_ratings
    end
      
      
   @all_ratings = Movie.all_ratings
   @selected_ratings = params[:ratings] || session[:ratings] || nil
   
   
  if @selected_ratings == nil
    @selected_ratings= Hash[@all_ratings.map {|x| [x , x] }]
  end
  
  if params[:ratings] != session[:ratings] || params[:sort] != session[:sort]
    session[:sort]=sort_choice
    session[:ratings] = @selected_ratings
    flash.keep
    redirect_to movies_path(:sort => sort_choice, :ratings => @selected_ratings) and return
  end
  
 # if !(params[:ratings].nil?)
 # @selected_ratings = params[:ratings]
 # session[:ratings] = @selected_ratings
 # @movies = Movie.where(:rating => @selected_ratings.keys)
 # end
  
    @movies = Movie.where(:rating => @selected_ratings.keys).order(sort_choice)
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
