require 'logging'

class SalesController < ApplicationController

  include Logging

  def index
    @user = User.find(params[:user_id])
    @sales = @user.sales

    respond_to do |format|
      format.html { head :no_content }
      format.json {
        log_event(:sales, :retrieve_sales, @sales)
        Sale.delete_all(:user_id => params[:user_id])
        render json: @sales.as_json(:only => [:user_id, :fbid, :post_id, :amount])
      }
    end
  end

end
