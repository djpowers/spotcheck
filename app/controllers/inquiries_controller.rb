class InquiriesController < ApplicationController

  def create
    @inquiry = Inquiry.inquiry_payload(params)

    if @inquiry.deliver
      flash[:notice] = 'Inquiry was successfully submitted.'
      redirect_to root_path
    else
      render :new
    end
  end

end
