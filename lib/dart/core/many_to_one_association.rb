module Dart
  class ManyToOneAssociation < DirectAssociation

    def type
      MANY_TO_ONE_TYPE
    end

    def associated_table
      parent_table
    end

    def to_one?
      true
    end

  end
end

