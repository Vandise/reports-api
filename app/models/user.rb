class User < ApplicationRecord
  rolify
  authenticates_with_sorcery!

  validates :company, presence: true
  validates :email, uniqueness: true
  before_create :normalize_email

  has_many :api_keys
  belongs_to :company

  def self.get_google_user(body, company)
    if user = find_by(email: body[:email].downcase)
      if !user.first_name || attributes = attributes_from_google(body, company)
        user.update_attributes(attributes)
      end
    end
    user
  end

  private

  def self.attributes_from_google(body, company)
    return unless valid_google_body?(body, company)
    {
      email: body[:email],
      first_name: body[:given_name],
      last_name: body[:family_name],
      google_account: true,
      profile_image: body[:picture]
    }
  end

  def self.valid_google_body?(body, company)
    body[:hd] == company.domain
  end

  def normalize_email
    self.email = email.downcase
  end

end
