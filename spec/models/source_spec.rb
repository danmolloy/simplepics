require 'rails_helper'

describe Source do
  describe '#initialize' do
    it "sets attributes" do
      input = {'width' => 100, 'height' => 1000, 'url' => 'www.google.com'}
      source = Source.new(input)
      expect(source).to have_attributes(width: 100, height: 1000, url: 'www.google.com')
    end
  end
end
