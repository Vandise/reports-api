require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  let(:user) { FactoryGirl.create(:user) }

  describe "creating" do
    it "sets the access_token and expires_at" do
      key = ApiKey.create(user: user)
      expect(key.access_token).to_not be_nil
      expect(key.expires_at).to_not be_nil
    end
  end

  describe ".active" do
    let!(:active_key) { ApiKey.create(user: user, expires_at: 1.hour.from_now) }
    let!(:inactive_key) { ApiKey.create(user: user, expires_at: 1.hour.ago) }

    it "returns only active ApiKeys" do
      expect(ApiKey.active.all).to eq [active_key]
    end
  end

  describe ".for_user!" do
    context "when no api key exists" do
      it "creates an api key" do
        expect{
          ApiKey.for_user!(user.id)
        }.to change { ApiKey.count }.by(1)
      end
    end

    context "when there is an api key" do
      context "and it is not expired" do
        let!(:key) { ApiKey.create(user: user, expires_at: 1.hour.from_now) }

        it "returns that key" do
          expect(ApiKey.for_user!(user.id)).to eq key
        end
      end

      context "but that key is expired" do
        let!(:key) { ApiKey.create(user: user, expires_at: 1.hour.ago) }

        it "creates an api key" do
          api_key = ApiKey.for_user!(user.id)
          expect(api_key.access_token).not_to eq key.access_token
        end

        it "destroys the old api_key" do
          expect(ApiKey.where(id: key.id).count).to eq 1
          ApiKey.for_user!(user.id)
          expect(ApiKey.where(id: key.id).count).to eq 0
        end
      end
    end
  end

  describe ".invalidate" do
    let!(:key) { ApiKey.create(user: user, expires_at: 1.hour.from_now) }

    it "sets the expires_at for the api key" do
      expect{
        ApiKey.invalidate(key.access_token)
      }.to change { key.reload.expires_at }
    end
  end
end