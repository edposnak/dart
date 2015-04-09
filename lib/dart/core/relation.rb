module Dart
  class Relation
    attr_reader :table_name, :column_names

    attr_reader :associations
    private :associations

    def initialize(table, columns)
      @table_name   = table.to_s.freeze
      @column_names = columns.map(&:to_s).map(&:freeze)
      @associations = []
    end

    # @return [Array<Association>] list of all associations on this relation
    def all_associations
      associations
    end

    # @return [Array<Association>] list of all direct (many_to_one or one_to_many) associations on this relation
    def direct_associations
      # associations - join_associations
      parent_associations + child_associations
    end

    # @return [Array<Association>] list of all join (many_to_many) associations on this relation
    def join_associations
      associations.select { |a| a.is_a?(ManyToManyAssociation) }
    end

    def parent_associations
      associations.select { |a| a.is_a?(ManyToOneAssociation) }
    end

    def child_associations
      associations.select { |a| a.is_a?(OneToManyAssociation) }
    end

    def add_association(ass)
      associations << ass
    end

    def to_s
      table_name
    end
  end
end
