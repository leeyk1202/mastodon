require 'rails_helper'

RSpec.describe Api::V1::PollsController, type: :controller do
  render_views

  let(:user)   { Fabricate(:user, account: Fabricate(:account, username: 'alice')) }
  let(:scopes) { 'read:statuses write:statuses' }
  let(:token)  { Fabricate(:accessible_access_token, resource_owner_id: user.id, scopes: scopes) }

  before { allow(controller).to receive(:doorkeeper_token) { token } }

  describe 'POST #create' do
    before do
      post :create, params: { options: %w(Foo Bar Baz), expires_at: 4.days.from_now.iso8601 }
    end

    it 'returns http success' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #show' do
    let(:poll) { Fabricate(:poll) }

    before do
      get :show, params: { id: poll.id }
    end

    it 'returns http success' do
      expect(response).to have_http_status(200)
    end
  end
end
