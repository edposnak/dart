module Dart
  module Reflection
    module SequelTable
      class ForeignKeyFinder

        # Returns the set of foreign keys on the given relation based on foreign key constraints defined in the db
        # @param [Relation] relation the relation to search
        # @param [Schema] schema defines the set of referenceable tables (and the db to search)
        # @return [Array<ForeignKeyInfo>] info for foreign keys in the given table and db
        #
        def foreign_keys_for(relation, schema)
          rows = schema.execute!(constraint_query(relation.table_name))
          rows.all.map { |attrs| ForeignKeyInfo.from_hash(attrs) }
        end

        private


        # @param [String|Symbol] table_name
        def constraint_query(table_name)
          # TODO incorporate namespaces

          # TODO reduce coupling with ForeignKeyInfo and Association fields by using constants from that class e.g.
          # "AS #{ForeignKeyInfo::CHILD_TABLE}"

          <<-CONSTRAINT_QUERY_SQL
                SELECT pg_constraint.conname AS constraint_name,
                       pg_class_con.relname AS child_table,
                       pg_attribute_con.attname AS foreign_key,
                       pg_class_ref.relname AS parent_table,
                       pg_attribute_ref.attname AS primary_key

                FROM pg_constraint,
                     pg_class pg_class_con,
                     pg_class pg_class_ref,
                     pg_attribute
                     pg_attribute_con,
                     pg_attribute pg_attribute_ref

                WHERE pg_class_con.relname = '#{table_name}' AND pg_constraint.contype = 'f' AND
                      pg_constraint.conrelid = pg_class_con.oid AND pg_attribute_con.attrelid = pg_constraint.conrelid AND pg_attribute_con.attnum = ANY (pg_constraint.conkey) AND
                      pg_constraint.confrelid = pg_class_ref.oid AND pg_attribute_ref.attrelid = pg_constraint.confrelid AND pg_attribute_ref.attnum = ANY (pg_constraint.confkey)

          CONSTRAINT_QUERY_SQL
        end

      end
    end
  end
end