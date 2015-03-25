class QuestionsController < ApplicationController
  def new
    @question = Question.new
  end

  def create
    new_params = question_params
    new_params[:user_id] = current_user.id
    @question = Question.new(new_params)
    if @question.save
      flash[:notice] = 'Question added.'
      redirect_to questions_path
    else
      render :new
    end
  end

  def index
    @questions = Question.order(created_at: :DESC).all
  end

  def destroy
    question_id = Question.find_by(id: params[:id])
    Question.destroy(question_id)
    Answer.destroy_all(question_id: params[:id])
    flash[:notice] = 'Question deleted.'
    redirect_to questions_path
  end

  def show
    @question = Question.find(params[:id])
    @answers = Answer.where(question_id: params[:id])
  end

  def edit
    @question = Question.find(params[:id])
    if current_user.nil? || User.find(@question.user_id).id != current_user.id
      flash[:notice] = "You can only edit your own questions."
      redirect_to question_path(params[:id])
    end
  end

  def update
    @question = Question.find(params[:id])
    new_params = question_params
    new_params[:user_id] = current_user.id
    if @question.update(new_params)
      flash[:notice] = 'Question edited.'
      redirect_to questions_path
    else
      render :new
    end
  end

  protected
  def question_params
    params.require(:question).permit(:title, :body)
  end
end
