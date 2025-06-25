class ChatController < ApplicationController
  before_action :require_signin

  def index
    @messages = current_user.chat_messages.order(:created_at)
  end

  def create
    message = current_user.chat_messages.create!(
      content: params[:message], 
      role: 'user'
    )
    
    # Call your Lambda function
    response = call_ai_service(params[:message])
    
    ai_message = current_user.chat_messages.create!(
      content: response, 
      role: 'assistant'
    )
    
    render json: { message: ai_message }
  end

  private

  def call_ai_service(message)
    # HTTP call to your API Gateway endpoint
    uri = URI(ENV['AI_LAMBDA_ENDPOINT'])
    response = Net::HTTP.post(uri, { message: message }.to_json, {
      'Content-Type' => 'application/json',
      'x-api-key' => ENV['AI_API_KEY']
    })
    
    JSON.parse(response.body)['response']
  end
end
