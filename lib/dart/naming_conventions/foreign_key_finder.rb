module Dart
  module NamingConventions
    class ForeignKeyFinder

      # Returns a set of possible foreign keys based on columns in this relation matching the naming convention and
      # reference a table name that is in the given schema
      #
      # @param [Relation] relation the relation to search
      # @param [Schema] schema defines the set of referenceable tables
      #
      def foreign_keys_for(relation, schema)
        naming_conventions = Dart::NamingConventions::AbstractBase.instance
        relation.column_names.map do |possible_foreign_key|
          if parent_table = naming_conventions.parent_table_for(possible_foreign_key)
            if schema.has_table?(parent_table)
              ForeignKeyInfo.new(relation.table_name,
                                 possible_foreign_key,
                                 parent_table,
                                 naming_conventions.conventional_primary_key)
            end
          end
        end.compact
      end
    end
  end
end