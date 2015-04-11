module Dart
  module Database
    # A Database::ManyToOneAssociation extends Dart::ManyToOneAssociation with naming conventions
    class ManyToOneAssociation < Dart::ManyToOneAssociation
      include NamingConventions::ManyToOneAssociationHelpers

      def initialize(*)
        super
        set_conventional_name!
      end

    end
  end
end
