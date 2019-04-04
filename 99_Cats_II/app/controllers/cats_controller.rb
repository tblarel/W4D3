class CatsController < ApplicationController

  # before_action user_owns_cat(), only[:edit,:update]

  def user_owns_cat(cat)
    current_user.cats.include?(cat)
  end

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.owner = current_user
    @cat.user_id = current_user.id

    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    if user_owns_cat(@cat)
      render :edit
    else
      render json: "Can't edit a cat you do not own" 
    end
  end

  def update
    @cat = Cat.find(params[:id])
    if user_owns_cat(@cat)
      if @cat.update_attributes(cat_params)
        redirect_to cat_url(@cat)
      else
        flash.now[:errors] = @cat.errors.full_messages
        render :edit
      end
    else
      renders json: "Can't edit a cat you do not own"
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:age, :birth_date, :color, :description, :name, :sex,:user_id)
  end
end
