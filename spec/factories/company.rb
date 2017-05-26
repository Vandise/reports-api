FactoryGirl.define do
  factory :company do
    name { FFaker::Company.name }
    domain { FFaker::Internet.domain_name }
  end
end