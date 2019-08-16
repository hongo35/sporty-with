class ApisController < ApplicationController
  def index
    render json: { 'status': 'ok' }
  end

  def callback
    client = Line::Bot::Client.new { |config|
      config.channel_secret = Rails.application.secrets.line_messaging_secret
      config.channel_token  = Rails.application.secrets.line_messaging_access_token
    }

    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end

    fp = File.open('line.log', 'a')

    events = client.parse_events_from(body)
    events.each { |event|
      fp.write(event.inspect)
      fp.write("\n")

      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          text = event.message['text']

          messages = [{
            type: 'text',
            text: '成功'
          }]

          client.reply_message(event['replyToken'], messages)
        end
      end
    }

    'ok'
  end
end
