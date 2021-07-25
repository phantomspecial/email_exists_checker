class InquiriesController < ApplicationController
  def new
    email = '---'
    # email = 'bounce@simulator.amazonses.com'

    post = Post.create(to_address: email)
    ses_result = ApplicationMailer.send_to_user(email).deliver_now

    ses_mid = ses_result.header.fields.select{|field| field.name == 'ses-message-id'}.first.value
    post.update(ses_message_id: ses_mid)

    render json: { message: "Send." }, status: :ok
  end
end
