class QuestionsController < ApplicationController
  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
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
    flash[:notice] = 'Question deleted.'
    redirect_to questions_path
  end

  def show
    @question = Question.find(params[:id])
    @answers = Answer.where(question_id: params[:id])
  end

  protected
  def question_params
    params.require(:question).permit(:title, :body)
  end
end
