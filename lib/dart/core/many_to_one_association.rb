module Dart
  class ManyToOneAssociation < DirectAssociation

    def type
      :many_to_one
    end

    def associated_table
      parent_table
    end

  end
end

