module Dart
  class OneToOneAssociation < DirectAssociation

    def type
      ONE_TO_ONE_TYPE
    end

    def associated_table
      child_table
    end

    def to_one?
      true
    end

  end
end
