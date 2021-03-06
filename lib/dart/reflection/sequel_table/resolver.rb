module Dart
  module Reflection
    module SequelTable
      class Resolver < AbstractResolver

        attr_reader :relation
        private :relation

        def initialize(table_name)
          @table_name = table_name
          @relation   = TheSchema.instance.relation_for(table_name)
        end

        # Returns the association with the given ass_name or nil if one does not exist
        # @param [String] ass_name
        # @return [Association]
        #
        def association_for(ass_name)
          ass = relation.all_associations.detect { |ass| ass.name == ass_name }
          ass.scope = {} # no scope can be determined by SQL reflection
          ass.resolver = self.class.new(ass.associated_table)
          ass
        end

        # Returns the column with the given col_name or nil if one does not exist
        # @param [String] col_name
        # @return [String]
        def column_for(col_name)
          relation.column_names.detect { |col| col == col_name }
        end

        def table_name
          @table_name
        end

        private

        class TheSchema
          include Singleton

          def relation_for(table_name)
            schema[table_name] or raise "no relation for '#{table_name}' was found in the schema"
          end

          def schema
            # Dart::Reflection::SequelTable::Reflector.new('postgres://smcc@localhost:5432/iapps_development').get_associations(:groups, naming_conventions: true) # setting naming_conventions to true might cause simple ass names to become more complex
            @schema ||= begin
              # TODO Benchmark.realtime
              Reflector.new('postgres://smcc@localhost:5432/iapps_development').get_schema_for_resolver(exclude_tables: /migration/)
            end
          end
        end

      end
    end
  end
end