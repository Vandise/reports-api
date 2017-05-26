class Company < ApplicationRecord
  resourcify
  has_many :users

  def self.find_by_domain(domain)
    where(domain: domain).first
  end

end