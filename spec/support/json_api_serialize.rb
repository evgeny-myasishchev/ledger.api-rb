# frozen_string_literal: true

module JsonApiSerialize
  def json_api_serialize(model, serializer: nil, each_serializer: nil)
    params = { adapter: :json_api,
               serializer: serializer,
               each_serializer: each_serializer }.reject { |_k, v| v.nil? }
    resource = ActiveModelSerializers::SerializableResource.new(model, params)
    JSON.parse(resource.to_json)
  end
end
