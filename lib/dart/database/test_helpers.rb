module Dart
  module Database

    # Test support class used to easily construct associations
    module TestHelpers
      def relation(*args)
        Relation.new(*args)
      end

      def many_to_one_ass(*args)
        ManyToOneAssociation.new(*args)
      end

      def one_to_many_ass(*args)
        OneToManyAssociation.new(*args)
      end

      def many_to_many_ass(*args)
        ManyToManyAssociation.new(*args)
      end
    end
  end
end