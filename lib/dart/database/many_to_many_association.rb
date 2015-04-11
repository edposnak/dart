module Dart
  module Database
    # A Database::ManyToManyAssociation extends Dart::ManyToManyAssociation with naming conventions
    class ManyToManyAssociation < Dart::ManyToManyAssociation
      include NamingConventions::ManyToManyAssociationHelpers

      def initialize(*)
        super
        set_conventional_name!
      end

    end
  end
end
