class APIMediaParser
  include ActiveModel::Model
  attr_accessor :media

  def simplify_image(image)
    Image.new(
      id: image['id'],
      created_at: image['created_time'],
      caption: image['caption'],
      link: image['link'],
      location: image['location'],
      thumbnail: Source.new(image['images']['thumbnail']),
      low_res: Source.new(image['images']['low_resolution']),
      standard_res: Source.new(image['images']['standard_resolution'])
    )
  end

  def simple_images_from_carousel(carousel)
    carousel['carousel_media'].map do |media|
      if media['type'] == 'image'
        image = carousel
        image.delete('carousel_media')
        image['images'] = media['images']
        simplify_image(image)
      end
    end
  end

  def is_image?(media)
    media['type'] == 'image' || media['type'] == 'carousel'
  end

  def images
    JSON.parse(@media.to_json).select{|m| is_image?(m)}.map do |media|
      case media['type']
        when 'image'    then simplify_image(media)
        when 'carousel' then simple_images_from_carousel(media)
      end
    end.flatten.compact
  end
end
