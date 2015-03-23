class AnswersController < ApplicationController
  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(answer_params)
    if @answer.save
      flash[:notice] = 'Answer added.'
      redirect_to question_path(question_id: params[:question_id])
    else
      render :new
    end
  end

  protected
  def answer_params
    params.require(:question).permit(:body)
  end
end
