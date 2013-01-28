class EarlyAccessController < ApplicationController

  def create
    @access = EarlyAccess.new(email_address: ( params[:early_access] ) ? params[:early_access][:email_address] : '' )
    @access.save
    respond_to do |format|
      format.js { render layout: false }
    end
  end
end
