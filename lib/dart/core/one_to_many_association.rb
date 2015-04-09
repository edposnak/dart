module Dart
  class OneToManyAssociation < DirectAssociation

    def type
      :one_to_many
    end

    def associated_table
      child_table
    end

  end
end
