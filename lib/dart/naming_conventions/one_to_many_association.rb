module Dart
  module NamingConventions
    class OneToManyAssociation < Dart::OneToManyAssociation
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
        if conventional_foreign_key?
          associated_table
        else
          "#{naming_conventions.singular_association_name(foreign_key)}_#{child_table}"
        end
      end

      def name_is_conventional?
        name == associated_table
      end

    end
  end
end

