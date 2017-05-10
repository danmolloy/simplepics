class Image
  include ActiveModel::Model
  attr_accessor :id, :created_at, :caption, :link, :location, :thumbnail,
  :low_res, :standard_res
end
