# frozen_string_literal: true

module MatchingLedgerHelpers
  def should_fail_with_ledger_not_found(response, ledger)
    expect(response).to have_http_status(404)
    expect(JSON.parse(response.body))
      .to eql('errors' => [
                { 'code' => 'Not Found', 'status' => 404, 'title' => "Ledger not found (id=#{ledger.id})" }
              ])
  end
end
