module Dart
  module Reflection
    module Sequel
      module Sequelizer

        # Converts the given identifier to the format needed by Sequel gem
        def sequelize(id)
          id.to_sym
        end

      end
    end
  end
end