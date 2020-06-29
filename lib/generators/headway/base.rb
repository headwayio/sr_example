module Headway
  module Generators
    class Base < Rails::Generators::NamedBase
      def self.source_root(path = nil)
        return path if path.present?
        templates = File.join(File.dirname(__FILE__),
                              generator_name,
                              'templates')
        source_root File.expand_path(templates)
      end
    end
  end
end
