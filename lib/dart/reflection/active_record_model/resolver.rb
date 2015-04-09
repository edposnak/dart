module Dart
  module Reflection
    module ActiveRecordModel
      class Resolver < OrmModelResolver

        private

        def reflection_from(ass_name)
          this_model_class.reflect_on_association(active_recordize(ass_name))
        end

        def has_column?(col_name)
          this_model_class.column_names.include?(col_name)
        end

        def build_association(ass_reflection)
          association_class = ass_reflection.association_class
          ass = if association_class == ActiveRecord::Associations::HasManyThroughAssociation

                  join_ass  = ass_reflection.through_reflection # has_many through:
                  left_ass  = ManyToOneAssociation.new(child_table:  join_ass.table_name,
                                                       foreign_key:  join_ass.foreign_key,
                                                       parent_table: ass_reflection.active_record.table_name,
                                                       primary_key:  ass_reflection.active_record_primary_key)
                  right_ass = ManyToOneAssociation.new(child_table:  join_ass.table_name,
                                                       foreign_key:  ass_reflection.association_foreign_key,
                                                       parent_table: ass_reflection.table_name,
                                                       primary_key:  ass_reflection.association_primary_key)
                  ManyToManyAssociation.new(left_ass, right_ass)

                elsif association_class == ActiveRecord::Associations::HasManyAssociation
                  OneToManyAssociation.new(child_table:  ass_reflection.table_name,
                                           foreign_key:  ass_reflection.foreign_key,
                                           parent_table: ass_reflection.active_record.table_name,
                                           primary_key:  ass_reflection.active_record_primary_key)

                elsif association_class == ActiveRecord::Associations::BelongsToAssociation
                  # pk = ass_reflection.primary_key_column.name
                  ManyToOneAssociation.new(child_table:  ass_reflection.active_record.table_name,
                                           foreign_key:  ass_reflection.foreign_key,
                                           parent_table: ass_reflection.table_name,
                                           primary_key:  ass_reflection.association_primary_key)

                else
                  raise "don't yet know how to resolve associations of type '#{association_class}'"
                end


          # ass.model_class = ass_reflection.active_record
          ass.model_class = ass_reflection.klass
          ass.set_name!(ass_reflection.name)
          ass


        end

        # Converts the given identifier to the format needed by ActiveRecord
        def active_recordize(id)
          id.to_sym
        end

      end
    end
  end
end