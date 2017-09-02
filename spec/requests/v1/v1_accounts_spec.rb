require 'rails_helper'

RSpec.describe "V1::Accounts", type: :request do
  describe "GET /v1/accounts" do
    it "works! (now write some real specs)" do
      get v1_accounts_index_path
      expect(response).to have_http_status(200)
    end
  end
end
