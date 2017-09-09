# frozen_string_literal: true

describe DB do
  before(:each) do
    DB.client[:people].drop
  end

  describe 'find' do
    it 'should find a document' do
      doc1 = { name: 'Steve', country: 'GB' }
      doc2 = { name: 'Bob', country: 'UA' }
      doc3 = { name: 'Sam', country: 'UA' }
      DB.client[:people].insert_many [doc1, doc2, doc3]

      actual_docs = DB.find :people, country: 'UA'
      expect(actual_docs).to have_attributes count: 2
      expect(actual_docs.to_a.map { |doc| doc.reject { |k, _v| k == '_id' } }).to include(
        doc2.stringify_keys,
        doc3.stringify_keys
      )
    end
  end
end
