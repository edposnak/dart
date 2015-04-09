module Dart
  module NamingConventions
    class ManyToOneAssociation < Dart::ManyToOneAssociation
      include AssociationHelpers
      include DirectAssociationHelpers

      def initialize(*)
        super
        set_conventional_name!
      end

      # Returns the name of a referenced association according to the naming convention
      #
      # @return [String] the name of the referenced association
      #
      def conventional_name
        naming_conventions.singular_association_name(foreign_key)
      end

      def name_is_conventional?
        naming_conventions.plural_association_name(foreign_key) == associated_table
      end
    end
  end
end
