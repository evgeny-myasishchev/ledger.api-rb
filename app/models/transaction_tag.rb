# frozen_string_literal: true

class TransactionTag < ApplicationRecord
  belongs_to :tag

  before_create do
    # This will not be set automatically when assigning transaction.tags so setting to ledger of a tag
    # fk constraint will fail if assigning tag to transaction from different ledger
    self.ledger_id = tag.ledger_id
  end
end
