require 'rails_helper'
require Rails.root.join('lib', 'generators', 'headway', 'locale', 'locale_generator')

RSpec.describe Headway::Generators::LocaleGenerator do
  let(:generator) { Headway::Generators::LocaleGenerator.new(['foo']) }
  before do
    File.delete(path_to_file) if File.exist?(path_to_file)
  end

  describe '#create_initializer' do
    let(:path_to_file) { Rails.root.join('config','initializers','i18n.rb') }

    it 'creates the initializer file' do
      generator.create_initializer
      expect(File.open(path_to_file, 'r')).to_not be_blank
    end
  end

  describe '#create_helper' do
    let(:path_to_file) { Rails.root.join('app','helpers','i18n_helper.rb') }

    it 'creates the helper file' do
      generator.create_helper
      expect(File.open(path_to_file, "r")).to_not be_blank
    end
  end

  describe '#create_locale_file' do
    let(:path_to_file) { Rails.root.join('config', 'locales', 'views', 'foo', 'en.yml') }

    it 'creates a locale file' do
      generator.create_locale_file
      expect(File.open(path_to_file)).to_not be_blank
    end
  end
end
