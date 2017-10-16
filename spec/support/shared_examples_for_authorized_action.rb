# frozen_string_literal: true

shared_examples 'authorized action' do |method, params|
  let(:path) do
    path_param = params[:path]
    send path_param[:helper], path_param.except(:helper)
  end

  let(:permitted_scopes) do
    params[:permitted_scopes]
  end

  it 'responds with 401 if no auth header' do
    process method, path
    expect(response).to have_http_status(401)
    expect(JSON.parse(response.body))
      .to eql('errors' => [
                { 'code' => 'Unauthorized', 'status' => 401, 'title' => 'No Bearer token found in Authorization header' }
              ])
  end

  it 'responds with 401 if not a bearer token' do
    process method, path, headers: { Authorization: 'Basic fake' }
    expect(response).to have_http_status(401)
    expect(JSON.parse(response.body))
      .to eql('errors' => [
                { 'code' => 'Unauthorized', 'status' => 401, 'title' => 'No Bearer token found in Authorization header' }
              ])
  end

  it 'responds with 401 if token verification fails' do
    process method, path, with_invalid_auth_header
    expect(response).to have_http_status(401)
    expect(JSON.parse(response.body))
      .to eql('errors' => [
                { 'code' => 'Unauthorized', 'status' => 401, 'title' => 'Token verification failed: Signature verification raised' }
              ])
  end

  it 'responds with 403 if bad scopes' do
    process method, path, with_valid_auth_header(scope: 'not-read:accounts')
    expect(response).to have_http_status(403)
    expect(JSON.parse(response.body))
      .to eql('errors' => [
                { 'code' => 'Forbidden', 'status' => 403, 'title' => "Authorization failed. Permitted scopes: #{permitted_scopes}" }
              ])
  end
end
