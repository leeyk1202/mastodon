# frozen_string_literal: true
require 'swagger_helper'

RSpec.describe Api::V1::EndorsementsController, type: :request do
  path '/api/v1/endorsements' do
    get('list endorsements') do
      tags 'Api', 'V1', 'Endorsements'
      operationId 'v1EndorsementsListEndorsement'
      rswag_bearer_auth

      include_context 'user token auth'

      response(200, 'successful') do
        rswag_add_examples!
        run_test!
      end
    end
  end
end
