class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answers = @question.answers
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      flash[:success] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      flash[:success] = 'Your question successfully updated.'
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:success] = 'Question successfully deleted.'
      redirect_to questions_path
    else
      flash.now[:error] = 'You not owner of this question'
      render 'questions/show'
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :content, attachments_attributes: [:file])
  end
end
