module Dart
  class OneToManyAssociation < DirectAssociation

    def type
      ONE_TO_MANY_TYPE
    end

    def associated_table
      child_table
    end

  end
end
