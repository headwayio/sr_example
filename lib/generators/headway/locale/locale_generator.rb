module Headway
  module Generators
    class LocaleGenerator < Base
      def create_initializer
        copy_file 'i18n.rb', 'config/initializers/i18n.rb'
      end

      def create_helper
        copy_file 'i18n_helper.rb', 'app/helpers/i18n_helper.rb'
      end

      def create_locale_file
        empty_directory "config/locales/views/#{file_name}/"
        create_file("config/locales/views/#{file_name}/en.yml") do
          <<~FILE
            en:
              home:
                index:
                  page_title: "Hello world"
          FILE
        end
      end
    end
  end
end
