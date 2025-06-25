class ChatController < ApplicationController
  before_action :require_signin

  def index
    @messages = current_user.chat_messages.order(:created_at)
  end

  def create
    @message = current_user.chat_messages.build(
      content: params[:message],
      role: 'user'
    )

    @message.file.attach(params[:file]) if params[:file].present?
    @message.save!

    # Get AI response
    file_key = @message.file.attached? ? @message.file.key : nil
    response = call_ai_service({
      message: params[:message],
      file_key: file_key
    })

    @ai_message = current_user.chat_messages.create!(
      content: response,
      role: 'assistant'
    )

    @messages = current_user.chat_messages.order(:created_at)

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def call_ai_service(payload)
    # HTTP call to AWS Lambda endpoint
    uri = URI(Rails.application.credentials.ai[:lambda_endpoint])
    response = Net::HTTP.post(uri, payload.to_json, {
      'Content-Type' => 'application/json'
    })

    JSON.parse(response.body)['response']
  end
end
