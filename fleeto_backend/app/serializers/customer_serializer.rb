class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :email, :name
end