class Source
  include ActiveModel::Model
  attr_accessor :width, :height, :url

  def initialize(source)
    @width = source['width']
    @height = source['height']
    @url = source['url']
  end
end
