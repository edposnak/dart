module Dart
  module Database
    # A Database::Relation extends Dart::Relation with naming conventions to support table reflection
    class Relation < Dart::Relation
      include NamingConventions::RelationHelpers

      def add_many_to_one(*ass_args)
        add_association ManyToOneAssociation.new(*ass_args)
      end

      def add_one_to_many(*ass_args)
        add_association OneToManyAssociation.new(*ass_args)
      end

      def add_many_to_many(*ass_args)
        add_association ManyToManyAssociation.new(*ass_args)
      end

    end
  end
end
