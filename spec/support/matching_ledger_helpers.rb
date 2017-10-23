# frozen_string_literal: true

module MatchingLedgerHelpers
  def should_fail_with_ledger_not_found(response, entity)
    expect(response).to have_http_status(404)
    expect(JSON.parse(response.body))
      .to eql('errors' => [
                { 'code' => 'Not Found', 'status' => 404, 'title' => "#{entity.model_name} not found (id=#{entity.id})" }
              ])
  end
end
