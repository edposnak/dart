module Dart
  module Reflection
    module SequelModel
      class Resolver < OrmModelResolver
        include Sequel::Sequelizer

        private

        def reflection_from(ass_name)
          # TODO assert this_model_class == ass_reflection[:model]
          this_model_class.association_reflection(sequelize(ass_name))
        end

        def has_column?(col_name)
          sequelized_col_name = sequelize(col_name)
          this_model_class.columns.include?(sequelized_col_name)
        end

        ONE_TO_MANY_TYPE = :one_to_many
        MANY_TO_ONE_TYPE = :many_to_one
        MANY_TO_MANY_TYPE = :many_to_many

        def build_association(ass_reflection)
          associated_model_class = Module.const_get(ass_reflection[:class_name])

          ass = case ass_reflection[:type]
                when :one_to_one
                  OneToOneAssociation.new(child_table: associated_model_class.table_name, foreign_key: ass_reflection[:key],
                                          parent_table: this_model_class.table_name, primary_key: ass_reflection.primary_key)

                when :one_to_many
                  OneToManyAssociation.new(child_table: associated_model_class.table_name, foreign_key: ass_reflection[:key],
                                           parent_table: this_model_class.table_name, primary_key: ass_reflection.primary_key)

                when :many_to_one
                  ManyToOneAssociation.new(child_table: this_model_class.table_name, foreign_key: ass_reflection[:key],
                                           parent_table: associated_model_class.table_name, primary_key: ass_reflection.primary_key)

                when :many_to_many
                  left_ass = ManyToOneAssociation.new(child_table: ass_reflection[:join_table], foreign_key: ass_reflection[:left_key],
                                                      parent_table: this_model_class.table_name, primary_key: ass_reflection[:left_primary_key])
                  right_ass = ManyToOneAssociation.new(child_table: ass_reflection[:join_table], foreign_key: ass_reflection[:right_key],
                                                       parent_table: ass_reflection.associated_dataset.first_source, primary_key: ass_reflection.right_primary_key)
                  ManyToManyAssociation.new(left_ass, right_ass)

                # TODO :one_through_one
                # when :one_through_one

                else
                  raise "don't yet know how to resolve associations of type '#{ass_reflection[:type]}' model=#{associated_model_class} association=#{ass_reflection[:name]}"
                end

          ass.model_class = associated_model_class

          # ass.sql = ass_reflection.associated_dataset.sql
          ass.scope = scope_for_association(ass_reflection)

          ass.set_name!(ass_reflection[:name])
          ass
        end


        def scope_for_association(ass_reflection)
          dataset = ass_reflection.associated_dataset.qualify
          opts = dataset.opts
          result = QUERY_OPTIONS.map {|cond| [cond, opts[cond] && dataset.literal_append('', opts[cond])]}
          Hash[result]
        end

      end
    end
  end
end
