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

        # = Active Record Associations
        #
        # This is the root class of all associations ('+ Foo' signifies an included module Foo):
        #
        #   Association
        #     SingularAssociation
        #       HasOneAssociation + ForeignAssociation
        #         HasOneThroughAssociation + ThroughAssociation
        #       BelongsToAssociation
        #         BelongsToPolymorphicAssociation
        #     CollectionAssociation
        #       HasManyAssociation + ForeignAssociation
        #         HasManyThroughAssociation + ThroughAssociation

        def build_association(ass_reflection)
          # use class name because association_class is the actual class, not an instance of it, so === won't match it
          ass = case ass_reflection.association_class.name.demodulize   # is it possible to have activerecord without activesupport?
                when 'HasOneAssociation'
                  OneToOneAssociation.new(child_table: ass_reflection.table_name,
                                          foreign_key: ass_reflection.foreign_key,
                                          parent_table: ass_reflection.active_record.table_name,
                                          primary_key: ass_reflection.active_record_primary_key)

                # TODO HasOneThroughAssociation
                # when 'HasOneThroughAssociation'

                when 'HasManyAssociation'
                  OneToManyAssociation.new(child_table: ass_reflection.table_name,
                                           foreign_key: ass_reflection.foreign_key,
                                           parent_table: ass_reflection.active_record.table_name,
                                           primary_key: ass_reflection.active_record_primary_key)

                when 'BelongsToAssociation'
                  # pk = ass_reflection.primary_key_column.name
                  ManyToOneAssociation.new(child_table: ass_reflection.active_record.table_name,
                                           foreign_key: ass_reflection.foreign_key,
                                           parent_table: ass_reflection.table_name,
                                           primary_key: ass_reflection.association_primary_key)

                when 'HasManyThroughAssociation'
                  join_ass = ass_reflection.through_reflection # has_many through:
                  left_ass = ManyToOneAssociation.new(child_table: join_ass.table_name,
                                                      foreign_key: join_ass.foreign_key,
                                                      parent_table: ass_reflection.active_record.table_name,
                                                      primary_key: ass_reflection.active_record_primary_key)
                  right_ass = ManyToOneAssociation.new(child_table: join_ass.table_name,
                                                       foreign_key: ass_reflection.association_foreign_key,
                                                       parent_table: ass_reflection.table_name,
                                                       primary_key: ass_reflection.association_primary_key)
                  ManyToManyAssociation.new(left_ass, right_ass)

                # TODO BelongsToPolymorphicAssociation
                # when 'BelongsToPolymorphicAssociation'
                else
                  fail "don't yet know how to resolve associations of type '#{ass_reflection.association_class}' model=#{ass_reflection.klass} association=#{ass_reflection.name}"
                end

          ass.model_class = ass_reflection.klass

          ass.scope = scope_for_association(ass_reflection)

          ass.set_name!(ass_reflection.name)
          ass
        end

        # TODO just put the association_reflection in the association and get all the SQL including the JOINs from
        # the ORM
        def scope_for_association(ass_reflection)
          case ActiveRecord::VERSION::MAJOR
          when 3
            # in rails 3 ass_reflection.options contains everything except the where
            non_where_scope = ass_reflection.options.slice(*QUERY_OPTIONS)

            # in rails 3 where is in ass_reflection.options[:conditions]
            conds = ass_reflection.options[:conditions]
            conds = conds.call if conds.is_a?(Proc) # options[:conditions] could be a proc that needs to be evaluated
            scope_hash_from(ass_reflection.klass.where(conds).to_sql).merge(non_where_scope)

            # This one-liner almost works but adds an "AND fk IS NULL" that would need to be extracted out of the where
            # sql_string = ass_reflection.klass.new.association(ass_name).send(:scoped).to_sql

          when 4
            # TODO use scope chain for through associations e.g. Broadcast.tracked_conversations

            # With rails 4, it seems there is either a scope on the association reflection (which includes the target
            # scope) or just a target scope on the association itself
            sql_string = if scope = ass_reflection.scope
                ass_reflection.klass.instance_exec(&scope).to_sql
              else # just use the target scope
                model_class.new.association(ass_name).send(:target_scope).to_sql
              end

            scope_hash_from(sql_string)
          else
            fail "ActiveRecord version #{ActiveRecord::VERSION::MAJOR}.x is not supported"
          end
        end

        # Converts the given identifier to the format needed by ActiveRecord
        def active_recordize(id)
          id.to_sym
        end

      end
    end
  end
end