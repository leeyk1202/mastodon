# frozen_string_literal: true

require 'rails_helper'

describe 'Content-Security-Policy' do
  before { allow(SecureRandom).to receive(:base64).with(16).and_return('ZbA+JmE7+bK8F5qvADZHuQ==') }

  it 'sets the expected CSP headers' do
    get '/'

    expect(response_csp_headers)
      .to match_array(expected_csp_headers)
  end

  def response_csp_headers
    response
      .headers['Content-Security-Policy']
      .split(';')
      .map(&:strip)
  end

  def expected_csp_headers
    <<~CSP.split("\n").map(&:strip)
      base-uri 'none'
      child-src 'self' blob: http://cb6e6126.ngrok.io
      connect-src 'self' data: blob: http://cb6e6126.ngrok.io ws://cb6e6126.ngrok.io:4000
      default-src 'none'
      font-src 'self' http://cb6e6126.ngrok.io
      form-action 'self'
      frame-ancestors 'none'
      frame-src 'self' https:
      img-src 'self' data: blob: http://cb6e6126.ngrok.io
      manifest-src 'self' http://cb6e6126.ngrok.io
      media-src 'self' data: http://cb6e6126.ngrok.io
      script-src 'self' http://cb6e6126.ngrok.io 'wasm-unsafe-eval'
      style-src 'self' http://cb6e6126.ngrok.io 'nonce-ZbA+JmE7+bK8F5qvADZHuQ=='
      worker-src 'self' blob: http://cb6e6126.ngrok.io
    CSP
  end
end
