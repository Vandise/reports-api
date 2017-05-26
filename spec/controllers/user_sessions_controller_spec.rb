
require 'rails_helper'

describe UserSessionsController, type: :controller do
  let!(:user) { FactoryGirl.create(:user, email: 'test@test.com', password: 'password') }
  let(:parsed_body) { JSON.parse(response.body, symbolize_names: true) }

  describe "POST #create" do
    context "when a google id token is sent" do
      let(:google_response) do
        {
          email: 'test@localhost',
          hd: 'localhost',
          picture: nil,
          given_name: 'tester',
          family_name: 'test',
          aud: config_option('google_application_id')
        }
      end
      let(:response_double) { double(:response, body: JSON.unparse(google_response)) }

      before do
        company = FactoryGirl.create(:company, name: 'localhost', domain: 'localhost')
        FactoryGirl.create(:user, email: 'test@localhost', company: company)
        expect_any_instance_of(Faraday::Connection).to receive(:get).and_return(response_double)
      end

      it "authenticates from google" do
        post :create, params: { email: 'test@localhost', token: 'some token' }
        expect(response).to be_success
      end
    end
  end

  describe "POST #destroy" do
    let!(:user_api_key) { FactoryGirl.create(:api_key, user: user) }

    it "is successful" do
      post :destroy, params: { access_token: user_api_key.access_token }
      expect(response).to be_success
    end

    it "destroys the current_api_key" do
      expect {
        post :destroy, params: { access_token: user_api_key.access_token }
      }.to change { ApiKey.count }.by(-1)
    end
  end
end