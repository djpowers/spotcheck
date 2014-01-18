require 'spec_helper'
require 'carrierwave/test/matchers'

describe VideoFileUploader do
  include CarrierWave::Test::Matchers

  let(:uploader) do
    VideoFileUploader.new(FactoryGirl.build(:video), :video_file)
  end

  let(:path) do
    Rails.root.join('spec/file_fixtures/valid_video.mp4')
  end

  before do
    VideoFileUploader.enable_processing = true
  end

  after do
    VideoFileUploader.enable_processing = false
  end

  it 'stores without error' do
    expect(lambda { uploader.store!(File.open(path)) }).to_not raise_error
  end
end
