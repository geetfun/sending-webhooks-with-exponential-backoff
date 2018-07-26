class AddWebhookUrlToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :webhook_url, :string
  end
end
