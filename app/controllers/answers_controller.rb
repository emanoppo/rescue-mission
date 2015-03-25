class AnswersController < ApplicationController
  def new
    @answer = Answer.new
  end

  def create
    new_params = answer_params
    new_params[:user_id] = current_user.id
    new_params[:question_id] = params[:question_id]
    @answer = Answer.new(new_params)
    if @answer.save
      flash[:notice] = 'Answer added.'
      redirect_to question_path(@answer.question_id)
    else
      render :new
    end
  end

  protected
  def answer_params
    params.require(:answer).permit(:body)
  end
end
