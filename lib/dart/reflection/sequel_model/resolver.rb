module Dart
  module Reflection
    module SequelModel
      class Resolver < OrmModelResolver
        include Sequel::Sequelizer

        def default_where_sql
          # TODO consider using the more opaque .sql.split('WHERE') strategy
          dataset = this_model_class.dataset.qualify
          where_expr = dataset.opts[:where]
          where_expr && dataset.literal_append('', where_expr)

          # cleaner but seems less public and thus more brittle
          # where_expr && where_expr.sql_literal(dataset)
        end

        private

        def reflection_from(ass_name)
          # TODO assert this_model_class == ass_reflection[:model]
          this_model_class.association_reflection(sequelize(ass_name))
        end

        def has_column?(col_name)
          sequelized_col_name = sequelize(col_name)
          this_model_class.columns.include?(sequelized_col_name)
        end

        def build_association(ass_reflection)
          associated_model_class = Module.const_get(ass_reflection[:class_name])

          ass = case ass_reflection[:type]
                when :many_to_many
                  left_ass  = ManyToOneAssociation.new(child_table:  ass_reflection[:join_table], foreign_key: ass_reflection[:left_key],
                                                       parent_table: this_model_class.table_name, primary_key: ass_reflection[:left_primary_key])
                  right_ass = ManyToOneAssociation.new(child_table:  ass_reflection[:join_table], foreign_key: ass_reflection[:right_key],
                                                       parent_table: ass_reflection.associated_dataset.first_source, primary_key: ass_reflection.right_primary_key)
                  ManyToManyAssociation.new(left_ass, right_ass)

                when :many_to_one
                  ManyToOneAssociation.new(child_table:  this_model_class.table_name, foreign_key: ass_reflection[:key],
                                           parent_table: associated_model_class.table_name, primary_key: ass_reflection.primary_key)

                when :one_to_many
                  OneToManyAssociation.new(child_table:  associated_model_class.table_name, foreign_key: ass_reflection[:key],
                                           parent_table: this_model_class.table_name, primary_key: ass_reflection.primary_key)

                else
                  raise "don't yet know how to resolve associations of type '#{ass_reflection[:type]}'"
                end

          ass.model_class = associated_model_class
          ass.set_name!(ass_reflection[:name])
          ass
        end

      end
    end
  end
end