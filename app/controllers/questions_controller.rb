class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy, :subscribe, :unsubscribe]
  before_action :build_answer, only: [:show]
  after_action :publish_question, only: [:create]
  after_action :subscribe_owner, only: [:create]

  authorize_resource

  include Voted

  respond_to :json
  respond_to :js, only: [:subscribe, :unsubscribe]

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with(@answers = @question.answers)
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    @question = Question.create(question_params)
    respond_with @question
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  def subscribe
    respond_with(current_user.subscribe_to(@question))
  end

  def unsubscribe
    respond_with(current_user.unsubscribe_from(@question))
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def question_params
    params.require(:question).permit(:title, :content, attachments_attributes: [:file, :id, :_destroy]).merge(user: current_user)
  end

  def publish_question
    PrivatePub.publish_to('/questions', question: @question.to_json) if @question.valid?
  end

  def subscribe_owner
    current_user.subscribe_to(@question) if @question.valid?
  end
end
