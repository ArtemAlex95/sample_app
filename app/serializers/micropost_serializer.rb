class MicropostSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :content, :user_id
end
