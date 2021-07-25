class AwsSesController < ApplicationController
  protect_from_forgery

  def create
    # AWSからの正しいリクエストかどうかを判定する
    return render json: {}, status: :bad_request unless valid_request?

    request_json = JSON.parse(request.body.string)

    if request_json['Type'] == 'SubscriptionConfirmation'
      # SNSのVerification
      verify_subscribe_url(request_json)
    else
      ses_send_result = JSON.parse(JSON.parse(request.body.string)['Message'])
      destination_address = ses_send_result['mail']['destination'].first
      ses_message_id = ses_send_result['mail']['messageId']

      post = Post.find_by(to_address: destination_address, ses_message_id: ses_message_id, send_result: nil)

      # 更新対象がない＝すでに１回は送信している/レコードが見つからないのでreturn
      return render json: {}, status: :ok if post.nil?

      post.update(send_result: ses_send_result['notificationType'])

      if ses_send_result['notificationType'] == 'Delivery'
        # 送信成功処理
        # 送信しないリストに該当しない場合は正常完了メールを送信
        if Rails.application.credentials.dig(:ses_not_applicable_emails).exclude?(destination_address)
          ApplicationMailer.send_to_office.deliver_now

          p '####################################'
          p '####################################'
          p 'Send.'
          p '####################################'
          p '####################################'
        end
      else
        # バウンス処理
        ApplicationMailer.send_to_admin.deliver_now

        p '####################################'
        p '####################################'
        p 'Bounce Email Addresses'
        p destination_address
        p '####################################'
        p '####################################'
      end
    end

    render json: {}, status: :ok
  end

  private

  def verify_subscribe_url(request_json)
    uri = URI(request_json['SubscribeURL'])

    req = Net::HTTP::Get.new(uri)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') { |http| http.request(req) }
  end

  def valid_request?
    request.user_agent == Rails.application.credentials.dig(:ses_user_agent) &&
    JSON.parse(request.body.string)['TopicArn'] == Rails.application.credentials.dig(:ses_topic_arn)
  end
end
