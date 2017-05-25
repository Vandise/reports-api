class ApiKey < ApplicationRecord

  before_create :generate_access_token

  belongs_to :user

  scope :active, -> { where("expires_at IS NULL OR expires_at > ?", Time.now) }

  def self.for_user!(user_id)
    find_or_create(user_id: user_id)
  end

  def self.invalidate(access_token)
    active.where(access_token: access_token).first.update_attributes(expires_at: Time.now)
  end

  private

  def self.find_or_create(arg)
    active.where(arg).first || create_and_destroy(arg)
  end

  def self.create_and_destroy(arg)
    where(arg).destroy_all
    create(arg)
  end

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
      self.expires_at   ||= timeout.from_now
    end while self.class.exists?(access_token: access_token)
  end

  def timeout
    (config_option('dev_token_timeout') || 10).to_i.hours
  end

end
