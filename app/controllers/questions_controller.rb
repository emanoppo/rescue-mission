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
    if !@question.answer_id.nil?
      @answers = Answer.order(created_at: :ASC).where(question_id: params[:id]).where.not(id: @question.answer_id)
      @best_answer = Answer.find(@question.answer_id)
    else
      @answers = Answer.order(created_at: :ASC).where(question_id: params[:id])
    end
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
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
    if !params[:answer_id].nil?
      new_params[:answer_id] = params[:answer_id]
    end
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
    params.require(:question).permit(:title, :body, :answer_id)
  end
end
