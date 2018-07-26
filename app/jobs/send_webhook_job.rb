class SendWebhookJob < ApplicationJob
  queue_as :default

  MAX_RETRIES = 10

  def perform(webhook_url, data, retry_count=0)
    p "COUNT #{retry_count} : #{Time.zone.now} : Sending data to #{webhook_url}"

    # make request
    begin
      response = HTTP.post(webhook_url, json: data)
      successful = response.code == 200
    rescue StandardError => e
      p e.message
      successful = false
    end

    if successful
      p "Successful"

    elsif retry_count < MAX_RETRIES
      wait = 2 ** retry_count
      SendWebhookJob.set(wait: wait.seconds).perform_later(webhook_url, data, retry_count + 1)
    end
  end
end
