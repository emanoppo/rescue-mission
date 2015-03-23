class HomesController < ApplicationController
  def index
    @questions = Question.order(created_at: :DESC).all
  end
end
