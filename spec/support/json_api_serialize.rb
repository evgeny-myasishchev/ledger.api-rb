# frozen_string_literal: true

module JsonApiSerialize
  def json_api_serialize(model)
    ActiveModelSerializers::SerializableResource.new(model, adapter: :json_api)
  end
end
