class AuthorStatisticsSerializer
  include JSONAPI::Serializer

  set_type :author_statistics
  attributes :grouped_by, :group_value, :recipes_quantity, :likes_quantity
end
