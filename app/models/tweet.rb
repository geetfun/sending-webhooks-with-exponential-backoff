class Tweet < ApplicationRecord
  belongs_to :user

  after_create :send_create_webhook!

  def send_create_webhook!
    User.has_webhook_enabled.find_each do |user|
      SendWebhookJob.perform_later(user.webhook_url, {
        type: "tweet.created",
        id: id,
        body: body,
        user: {
          id: user_id,
          name: user.name,
        }
      })
    end
  end
end
