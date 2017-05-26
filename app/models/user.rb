class User < ApplicationRecord
  rolify
  authenticates_with_sorcery!

  validates :email, uniqueness: true
  before_create :normalize_email

  has_many :api_keys

  def self.get_google_user(body)
    if user = find_by(email: body[:email].downcase)
      if !user.first_name || attributes = attributes_from_google(body)
        user.update_attributes(attributes)
      end
    end
    user
  end

  private

  def self.attributes_from_google(body)
    {
      email: body[:email],
      first_name: body[:given_name],
      last_name: body[:family_name],
      google_account: true,
      profile_image: body[:picture]
    }
  end

  def normalize_email
    self.email = email.downcase
  end

end
