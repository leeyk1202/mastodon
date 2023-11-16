# frozen_string_literal: true

require 'rails_helper'

describe Admin::DashboardController do
  render_views

  describe 'GET #index' do
    let(:admin_user) { Fabricate(:user, role: UserRole.find_by(name: 'Admin')) }

    before do
      allow(Admin::SystemCheck).to receive(:perform).and_return(system_check_messages)
      sign_in admin_user
    end

    it 'returns 200' do
      get :index

      expect(response)
        .to have_http_status(200)
        .and render_template(:index)
    end

    private

    def system_check_messages
      [
        Admin::SystemCheck::Message.new(:database_schema_check),
        Admin::SystemCheck::Message.new(:rules_check, nil, admin_rules_path),
        Admin::SystemCheck::Message.new(:sidekiq_process_check, 'foo, bar'),
      ]
    end
  end
end
