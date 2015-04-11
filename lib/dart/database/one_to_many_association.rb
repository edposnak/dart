module Dart
  module Database
    # A Database::OneToManyAssociation extends Dart::OneToManyAssociation with naming conventions
    class OneToManyAssociation < Dart::OneToManyAssociation
      include NamingConventions::OneToManyAssociationHelpers

      def initialize(*)
        super
        set_conventional_name!
      end

    end
  end
end
