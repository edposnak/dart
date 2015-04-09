module Dart
  module NamingConventions
    module AssociationHelpers

      abstract_method :conventional_name, :name_is_conventional?

      def naming_conventions
        Dart::NamingConventions::AbstractBase.instance
      rescue
        raise "naming conventions have not been configured"
      end

      def set_conventional_name!
        set_name! conventional_name
      end
    end
  end
end