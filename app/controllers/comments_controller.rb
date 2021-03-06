class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:moderate]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  def updateStatus
    id = params[:id]
    idcomment = params[:idcomment]
    if id == "accept"
      @comment = Comment.find(idcomment)
      @comment.status = 1
    end
    if @comment.save  
      respond_to do |format|
         format.html
         format.js {} 
         format.json { 
            render json: {:message => id}
        } 
      end
    else
      format.html { render :show }
      format.json { render json: @deal.errors, status: :unprocessable_entity }

    end

  end
  def moderate
    if params[:status].present?
      @comments = Comment.where('status = '+params[:status])
    else
      @comments = Comment.all
    end
      @comments0 = Comment.where('status = 0').count
      @comments1 = Comment.where('status = 1').count
      @comments2 = Comment.where('status = 2').count
      @comments3 = Comment.all.count
  end

  def saveComment
    if user_signed_in?
    promoid = params[:promoid]
    description = params[:description]
    parent = params[:parent]
    status = 0
    userid = current_user.id
    @comment = Comment.new(description: description, user_id: userid, deal_id: promoid, status: status, parent: parent)
    @comment.save
    respond_to do |format|
       format.html
       format.js {} 
       format.json { 
          render json: {:message => 'Tu commentario está en revisión, pronto lo publicaremos.'}
      } 
    end
    end    
  end
  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.status = 2
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to '/moderatecomments/', notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:description, :user_id, :deal_id, :status)
    end

    def admin_user
     if current_user.try(:admin?)
       flash.now[:success] = "Admin Access Granted"
      else
       redirect_to root_path
      end
    end
end
