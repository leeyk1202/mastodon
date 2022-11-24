require 'rails_helper'

RSpec.describe Api::V1::MediaController, type: :controller do
  render_views

  let(:user)  { Fabricate(:user) }
  let(:token) { Fabricate(:accessible_access_token, resource_owner_id: user.id, scopes: 'write:media') }

  before do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe 'POST #create' do
    describe 'with paperclip errors' do
      let(:media_attachment) { double(MediaAttachment) }
      let(:account) { Fabricate(:account) }
      let(:token) { Fabricate(:accessible_access_token, resource_owner_id: account.user.id, scopes: 'write:media') }
    
      before do
        allow(controller).to receive(:doorkeeper_token) { token }
        allow(MediaAttachment).to receive(:new).and_return(media_attachment)
        %i[_has_attribute? new_record? _write_attribute create! association].each do |method|
          allow(media_attachment).to receive(method)
        end
      end

      context 'when imagemagick cant identify the file type' do
        it 'returns http 422' do
          expect(media_attachment).to receive(:save!).and_raise(Paperclip::Errors::NotIdentifiedByImageMagickError)
          post :create, params: { file: fixture_file_upload('attachment.jpg', 'image/jpeg') }
          expect(response).to have_http_status(:unprocessable_entity).and(
            having_attributes(
              body: a_string_including({ error: 'File type of uploaded media could not be verified' }.to_json)
            )
          )
        end
      end

      context 'when there is a generic error' do
        it 'returns http 500' do
          expect(media_attachment).to receive(:save!).and_raise(Paperclip::Error)
          post :create, params: { file: fixture_file_upload('attachment.jpg', 'image/jpeg') }
          expect(response).to have_http_status(500).and(
            having_attributes(
              body: a_string_including({ error: 'Error processing thumbnail for uploaded media' }.to_json)
            )
          )
        end
      end
    end

    context 'image/jpeg' do
      before do
        post :create, params: { file: fixture_file_upload('attachment.jpg', 'image/jpeg') }
      end

      it 'returns http success' do
        expect(response).to have_http_status(200)
      end

      it 'creates a media attachment' do
        expect(MediaAttachment.first).to_not be_nil
      end

      it 'uploads a file' do
        expect(MediaAttachment.first).to have_attached_file(:file)
      end

      it 'returns media ID in JSON' do
        expect(body_as_json[:id]).to eq MediaAttachment.first.id.to_s
      end
    end

    context 'image/gif' do
      before do
        post :create, params: { file: fixture_file_upload('attachment.gif', 'image/gif') }
      end

      it 'returns http success' do
        expect(response).to have_http_status(200)
      end

      it 'creates a media attachment' do
        expect(MediaAttachment.first).to_not be_nil
      end

      it 'uploads a file' do
        expect(MediaAttachment.first).to have_attached_file(:file)
      end

      it 'returns media ID in JSON' do
        expect(body_as_json[:id]).to eq MediaAttachment.first.id.to_s
      end
    end

    context 'video/webm' do
      before do
        post :create, params: { file: fixture_file_upload('attachment.webm', 'video/webm') }
      end

      it do
        # returns http success
        expect(response).to have_http_status(200)

        # creates a media attachment
        expect(MediaAttachment.first).to_not be_nil

        # uploads a file
        expect(MediaAttachment.first).to have_attached_file(:file)

        # returns media ID in JSON
        expect(body_as_json[:id]).to eq MediaAttachment.first.id.to_s
      end
    end
  end

  describe 'PUT #update' do
    context 'when somebody else\'s' do
      let(:media) { Fabricate(:media_attachment, status: nil) }

      it 'returns http not found' do
        put :update, params: { id: media.id, description: 'Lorem ipsum!!!' }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the author \'s' do
      let(:status) { nil }
      let(:media)  { Fabricate(:media_attachment, status: status, account: user.account) }

      before do
        put :update, params: { id: media.id, description: 'Lorem ipsum!!!' }
      end

      it 'updates the description' do
        expect(media.reload.description).to eq 'Lorem ipsum!!!'
      end

      context 'when already attached to a status' do
        let(:status) { Fabricate(:status, account: user.account) }

        it 'returns http not found' do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
