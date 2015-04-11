require 'sequel'

module Dart
  module Reflection
    module Sequel
      class NamingConventions < Dart::NamingConventions::AbstractBase

        include ::Sequel::Inflections # for pluralize and singularize

        def conventional_primary_key
          'id'
        end

        def foreign_key_regex
          /_id$/
        end

      end
    end

    Dart::NamingConventions.instance = Sequel::NamingConventions.new
  end
end


