require 'rails_helper'

RSpec.describe User, type: :model do

  describe "password presence validation" do

    let(:user) { FactoryGirl.build_stubbed(:user) }

    context "when the account is a google account" do
      context "when creating" do
        it "does not require a password" do
          user = User.new(email: 'auniqueemail@company.com', google_account: true)
          expect(user).to be_valid
        end
      end

      context "when updating other fields" do
        it "does not require a password" do
          user.password = nil
          user.email = 'anotheremail@email.xyz'
          expect(user).to be_valid
        end
      end

      context "when updating" do
        let(:user) { FactoryGirl.build_stubbed(:user, email: 'blah@company.com', google_account: true) }

        it "does not require a password" do
          user.password = '123'
          expect(user).to be_valid
        end
      end
    end
  end

  describe ".get_google_user" do
    context "with a domain" do
      let(:body) do
        {
          email: 'test@company.com',
          given_name: 'test',
          family_name: 'testing',
          hd: 'company.com'
        }
      end

      context "and the user already exists" do
        context "and their attributes have not been set yet" do
          let!(:user) { FactoryGirl.create(:user, email: 'test@company.com', first_name: 'test', last_name: 'test') }

          it "updates the attributes" do
            expect(user.first_name).to eq('test')
            expect(user.last_name).to eq('test')
            user = User.get_google_user(body)
            expect(user.first_name).to_not be_nil
            expect(user.last_name).to_not be_nil
          end
        end

        context "and their attributes have been set" do
          let!(:user) { FactoryGirl.create(:user, email: 'test@company.com') }

          it "does nothing" do
            first_name = user.first_name
            last_name = user.last_name
            user = User.get_google_user(body)
            expect(user.first_name).to eq(first_name)
            expect(user.last_name).to eq(last_name)
          end
        end
      end
    end
  end
end