# frozen_string_literal: true

# @let request
RSpec.shared_examples_for 'a request that require authentication' do
  it 'requires authentication' do
    request
    expect(response).to have_http_status(:unauthorized)
  end
end

# @let request_type
# @let request_url
RSpec.shared_context 'with an http request' do
  # rubocop:disable RSpec/InstanceVariable
  let(:request) { send(request_type, request_url, params: @params, headers: @headers, as: :json) }
  # rubocop:enable RSpec/InstanceVariable
end
