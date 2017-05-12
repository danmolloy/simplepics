require 'rails_helper.rb'

describe APIParser do
  describe '#simplify_image' do
    before :all do
      @media = JSON.parse(file_fixture('media.json').read)
      @parser = APIParser.new(media: @media)
      @image = @media.select{|m| m['type'] == 'image'}.first
    end
    it "returns an Image" do
      expect(@parser.simplify_image(@image)).to be_instance_of Image
    end
    it "sets Image attributes correctly" do
      expect(@parser.simplify_image(@image)).to have_attributes(
        id: @image['id'],
        created_at: @image['created_time'],
        caption: @image['caption'],
        link: @image['link'],
        location: @image['location']
      )
    end
    it "sets Image thumbnail correctly" do
      expect(@parser.simplify_image(@image).thumbnail).to have_attributes(
        width: @image['images']['thumbnail']['width'],
        height: @image['images']['thumbnail']['height'],
        url: @image['images']['thumbnail']['url']
      )
    end
    it "sets Image low_res correctly" do
      expect(@parser.simplify_image(@image).low_res).to have_attributes(
        width: @image['images']['low_resolution']['width'],
        height: @image['images']['low_resolution']['height'],
        url: @image['images']['low_resolution']['url']
      )
    end
    it "sets Image standard_res correctly" do
      expect(@parser.simplify_image(@image).standard_res).to have_attributes(
        width: @image['images']['standard_resolution']['width'],
        height: @image['images']['standard_resolution']['height'],
        url: @image['images']['standard_resolution']['url']
      )
    end
  end

  describe '#simple_images_from_carousel' do
    before :all do
      @media = JSON.parse(file_fixture('media.json').read)
      @parser = APIParser.new(media: @media)
      @carousel = @media.select{|m| m['type'] == 'carousel'}.first
      @images = @parser.simple_images_from_carousel(@carousel)
    end
    it "returns a collection of Images" do
      expect(@images).to all(be_instance_of Image)
    end
    it "creates an Image for each image in input" do
      expect(@images.length).to eq 3
    end
    it "returns an empty array if nothing in input is an image" do
      bad_carousel = {'carousel_media' => [{'type' => 'video'}, {'type' => 'mp3'}]}
      expect(@parser.simple_images_from_carousel(bad_carousel)).to eq []
    end
  end

  describe '#is_image?' do
    before :all do
      @parser = APIParser.new
    end
    it "returns true if given an image" do
      expect(@parser.is_image?({'type' => 'image'})).to be true
    end
    it "returns true if given a carousel" do
      expect(@parser.is_image?({'type' => 'carousel'})).to be true
    end
    it "returns false if not given an image or carousel" do
      expect(@parser.is_image?({'type' => 'video'})).to be false
    end
  end

  describe '#images' do
    before :all do
      @media = JSON.parse(file_fixture('media.json').read)
      @parser = APIParser.new(media: @media)
    end
    it "returns nil if @media is not set" do
      expect(APIParser.new.images).to be_nil
    end
    it "returns an empty array if nothing in @media is an Image" do
      @media = {video: {'type' => 'video'}, music: {'type' => 'mp3'}}
      expect(APIParser.new(media: @media).images).to eq []
    end
    it "returns a collection of Images" do
      expect(@parser.images).to all(be_instance_of Image)
    end
    it "creates an Image for each image in @media" do
      pics = @media.select{|m| m['type'] == 'image'}.first(5)
      expect(APIParser.new(media: pics).images.length).to eq 5
    end
    it "creates Images for all images in each carousel" do
      carousel = @media.select{|m| m['type'] == 'carousel'}
      expect(APIParser.new(media: carousel).images.length).to eq 3
    end
  end
end
