class PostItemsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])

    respond_to do |format|
      if @post.post_items.create(params[:post_item])
        format.html { redirect_to @post, notice: 'Post item was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
end
