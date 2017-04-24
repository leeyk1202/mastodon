require 'rails_helper'

RSpec.describe Api::V1::StatusesController, type: :controller do
  render_views

  let(:user)  { Fabricate(:user, account: Fabricate(:account, username: 'alice')) }
  let(:app)   { Fabricate(:application, name: 'Test app', website: 'http://testapp.com') }

  context 'with an oauth token' do
    let(:token) { double acceptable?: true, resource_owner_id: user.id, application: app }

    before do
      request.headers['Authorization'] = "Bearer blah"
      allow(controller).to receive(:doorkeeper_token) { token }
    end

    describe 'GET #show' do
      let(:status) { Fabricate(:status, account: user.account) }

      it 'returns http success' do
        get :show, params: { id: status.id }
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET #context' do
      let(:status) { Fabricate(:status, account: user.account) }

      before do
        Fabricate(:status, account: user.account, thread: status)
      end

      it 'returns http success' do
        get :context, params: { id: status.id }
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET #reblogged_by' do
      let(:status) { Fabricate(:status, account: user.account) }

      before do
        post :reblog, params: { id: status.id }
      end

      it 'returns http success' do
        get :reblogged_by, params: { id: status.id }
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET #favourited_by' do
      let(:status) { Fabricate(:status, account: user.account) }

      before do
        post :favourite, params: { id: status.id }
      end

      it 'returns http success' do
        get :favourited_by, params: { id: status.id }
        expect(response).to have_http_status(:success)
      end
    end

    describe 'POST #create' do
      before do
        post :create, params: { status: 'Hello world' }
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end

    describe 'DELETE #destroy' do
      let(:status) { Fabricate(:status, account: user.account) }

      before do
        post :destroy, params: { id: status.id }
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'removes the status' do
        expect(Status.find_by(id: status.id)).to be nil
      end
    end

    describe 'POST #reblog' do
      let(:status) { Fabricate(:status, account: user.account) }

      before do
        post :reblog, params: { id: status.id }
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'updates the reblogs count' do
        expect(status.reblogs.count).to eq 1
      end

      it 'updates the reblogged attribute' do
        expect(user.account.reblogged?(status)).to be true
      end

      it 'return json with updated attributes' do
        hash_body = body_as_json

        expect(hash_body[:reblog][:id]).to eq status.id
        expect(hash_body[:reblog][:reblogs_count]).to eq 1
        expect(hash_body[:reblog][:reblogged]).to be true
      end
    end

    describe 'POST #unreblog' do
      let(:status) { Fabricate(:status, account: user.account) }

      before do
        post :reblog,   params: { id: status.id }
        post :unreblog, params: { id: status.id }
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'updates the reblogs count' do
        expect(status.reblogs.count).to eq 0
      end

      it 'updates the reblogged attribute' do
        expect(user.account.reblogged?(status)).to be false
      end
    end

    describe 'POST #favourite' do
      let(:status) { Fabricate(:status, account: user.account) }

      before do
        post :favourite, params: { id: status.id }
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'updates the favourites count' do
        expect(status.favourites.count).to eq 1
      end

      it 'updates the favourited attribute' do
        expect(user.account.favourited?(status)).to be true
      end

      it 'return json with updated attributes' do
        hash_body = body_as_json

        expect(hash_body[:id]).to eq status.id
        expect(hash_body[:favourites_count]).to eq 1
        expect(hash_body[:favourited]).to be true
      end
    end

    describe 'POST #unfavourite' do
      let(:status) { Fabricate(:status, account: user.account) }

      before do
        post :favourite,   params: { id: status.id }
        post :unfavourite, params: { id: status.id }
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'updates the favourites count' do
        expect(status.favourites.count).to eq 0
      end

      it 'updates the favourited attribute' do
        expect(user.account.favourited?(status)).to be false
      end
    end
  end

  context 'without an oauth token' do
    context 'with a private status' do
      let(:status) { Fabricate(:status, account: user.account, visibility: :private) }

      describe 'GET #show' do
        it 'returns http missing' do
          get :show, params: { id: status.id }
          expect(response).to have_http_status(:missing)
        end
      end

      describe 'GET #context' do
        before do
          Fabricate(:status, account: user.account, thread: status)
        end

        it 'returns http missing' do
          get :context, params: { id: status.id }
          expect(response).to have_http_status(:missing)
        end
      end

      describe 'GET #card' do
        it 'returns http missing' do
          get :card, params: { id: status.id }
          expect(response).to have_http_status(:missing)
        end
      end

      describe 'GET #reblogged_by' do
        before do
          post :reblog, params: { id: status.id }
        end

        it 'returns http missing' do
          get :reblogged_by, params: { id: status.id }
          expect(response).to have_http_status(:missing)
        end
      end

      describe 'GET #favourited_by' do
        before do
          post :favourite, params: { id: status.id }
        end

        it 'returns http missing' do
          get :favourited_by, params: { id: status.id }
          expect(response).to have_http_status(:missing)
        end
      end
    end

    context 'with a public status' do
      let(:status) { Fabricate(:status, account: user.account, visibility: :public) }

      describe 'GET #show' do
        it 'returns http success' do
          get :show, params: { id: status.id }
          expect(response).to have_http_status(:success)
        end
      end

      describe 'GET #context' do
        before do
          Fabricate(:status, account: user.account, thread: status)
        end

        it 'returns http success' do
          get :context, params: { id: status.id }
          expect(response).to have_http_status(:success)
        end
      end

      describe 'GET #card' do
        it 'returns http success' do
          get :card, params: { id: status.id }
          expect(response).to have_http_status(:success)
        end
      end

      describe 'GET #reblogged_by' do
        before do
          post :reblog, params: { id: status.id }
        end

        it 'returns http success' do
          get :reblogged_by, params: { id: status.id }
          expect(response).to have_http_status(:success)
        end
      end

      describe 'GET #favourited_by' do
        before do
          post :favourite, params: { id: status.id }
        end

        it 'returns http success' do
          get :favourited_by, params: { id: status.id }
          expect(response).to have_http_status(:success)
        end
      end
    end
  end

  context 'with a bogus oauth token' do
    let(:status) { Fabricate(:status, account: user.account) }

    before do
      request.headers['Authorization'] = "Bearer blah"
    end

    describe 'GET #show' do
      it 'returns http unauthorized' do
        get :show, params: { id: status.id }
        expect(response).to have_http_status(401)
      end
    end

    describe 'GET #context' do
      before do
        Fabricate(:status, account: user.account, thread: status)
      end

      it 'returns http unauthorized' do
        get :context, params: { id: status.id }
        expect(response).to have_http_status(401)
      end
    end

    describe 'GET #card' do
      it 'returns http unauthorized' do
        get :card, params: { id: status.id }
        expect(response).to have_http_status(401)
      end
    end

    describe 'GET #reblogged_by' do
      before do
        post :reblog, params: { id: status.id }
      end

      it 'returns http unauthorized' do
        get :reblogged_by, params: { id: status.id }
        expect(response).to have_http_status(401)
      end
    end

    describe 'GET #favourited_by' do
      before do
        post :favourite, params: { id: status.id }
      end

      it 'returns http unauthorized' do
        get :favourited_by, params: { id: status.id }
        expect(response).to have_http_status(401)
      end
    end
  end
end
