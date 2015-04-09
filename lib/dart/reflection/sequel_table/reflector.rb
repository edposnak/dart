module Dart
  module Reflection
    module SequelTable
      class Reflector

        attr_reader :db
        private :db

        # @param [String] database_url specifies database to reflect on
        #
        def initialize(database_url)
          @db = ::Sequel.connect(database_url)
        end

        # @param [Hash] options
        # @option options exclude_tables an Array or Regexp defining tables to exclude from the reflection
        # @option options naming_conventions identify direct associations by column naming conventions (e.g. users.group_id => Group one_to_many users)
        # @return [Array<Relation>]
        #
        def get_relations_for_code_gen(options={})
          schema = get_schema(options)
          create_join_associations_for_codegen!(schema, options)

          schema.relations
        end

        # @param [Hash] options
        # @option options exclude_tables an Array or Regexp defining tables to exclude from the reflection
        # @option options naming_conventions identify direct associations by column naming conventions (e.g. users.group_id => Group one_to_many users)
        # @return [Array<Relation>]
        #
        def get_schema_for_resolver(options={})
          schema = get_schema(options)
          create_join_associations_for_resolver!(schema, options)
          schema
        end

        private

        # @param [Hash] options
        # @option options exclude_tables an Array or Regexp defining tables to exclude from the reflection
        # @option options naming_conventions identify direct associations by column naming conventions (e.g. users.group_id => Group one_to_many users)
        # @return [Array<Relation>]
        #
        def get_schema(options={})
          exclude_tables = options.delete(:exclude_tables)
          db_tables      = case exclude_tables
                           when Enumerable
                             db.tables - exclude_tables.map(&:to_sym)
                           when Regexp
                             db.tables.reject { |t| exclude_tables.match(t) }
                           else # don't exclude any tables
                             db.tables
                           end

          fk_finder = if options[:naming_conventions]
                        NamingConventions::ForeignKeyFinder.new
                      else
                        SequelTable::ForeignKeyFinder.new
                      end


          # "\nThe following tables were searched\n:#{db_tables}"
          schema = Schema.new(db, db_tables)
          create_direct_associations!(schema, fk_finder)
          schema
        end

        def create_direct_associations!(schema, foreign_key_finder)
          schema.relations.each do |relation|
            foreign_keys = foreign_key_finder.foreign_keys_for(relation, schema)

            foreign_keys.each do |foreign_key|
              if one_relation = schema.relation(foreign_key.parent_table)
                many_to_one_ass = NamingConventions::ManyToOneAssociation.new(foreign_key)
                relation.add_association many_to_one_ass

                one_to_many_ass = NamingConventions::OneToManyAssociation.new(foreign_key)
                one_relation.add_association one_to_many_ass
              else
                fail "schema does not contain a table named '#{foreign_key.parent_table}'. Perhaps it was excluded accidentally?"
              end
            end
          end
        end


        # there are 2 ways to infer join association names from the database
        # 1. by assigning short names and then disambiguating conflicts
        #    example: Group many_to_many :topics, join_table: :topic_assignments
        # 2. by assigning longs names that don't conflict (either with direct associations or other joins)
        #    example: Group many_to_many :topic_assignment_topics, join_table: :topic_assignments
        #
        # neither method will correctly guess Group many_to_many :assigned_topics, join_table: :topic_assignments
        #
        # Method 1 is useful for generating code with suggested association names from an existing db.
        # Method 2 is useful for resolving association names from the schema. However, a major drawback of 2 is it will
        #          almost always guess wrong for conventional joins, for example, by generating
        #          Group many_to_many :groups_users_users, join_table: groups_users
        #          instead of
        #          Group many_to_many :users, join_table: groups_users
        #
        # Method 2 could be 'improved' by a strictish option that uses long names except in the case where a
        # conventional join table name is used. The -ish means any combination of 'groups_users', 'group_users',
        # 'group_user', 'user_groups', etc. is allowed. This can lead to conflicts if there were multiple join tables
        # that meet the criteria of -ish.
        #
        # Or better yet ...
        #
        # A resolver could start with some association name, e.g. groups.users and, seeing that there is no direct
        # association, then look for all possible join tables (i.e. those with parent associations to both users and
        # groups) and choose the best one (i.e. the one named groups_users, or users_groups, or ...)
        #
        # For now, they are one and the same ...
        #
        def create_join_associations_for_codegen!(schema, options={})
          create_join_associations!(schema, options)
        end

        def create_join_associations_for_resolver!(schema, options={})
          create_join_associations!(schema, options)
        end

        def create_join_associations!(schema, options={})
          schema.relations.each do |relation|
            relation.possible_join_pairs.each do |ass1, ass2|
              r1, r2 = schema[ass1.parent_table], schema[ass2.parent_table]

              # skip if either relation already has a direct, conventional association to the other
              # e.g. don't users many_to_many groups if users has group_id
              # e.g do users many_to_many groups if users has reporting_group_id (many_to_one reporting_group, and many_to_many groups)
              next if r1.has_direct_conventional_parent?(r2.table_name) || r2.has_direct_conventional_parent?(r1.table_name)

              many_to_many_ass1 = NamingConventions::ManyToManyAssociation.new(ass1, ass2)
              r1.add_association many_to_many_ass1

              many_to_many_ass2 = NamingConventions::ManyToManyAssociation.new(ass2, ass1)
              many_to_many_ass2.set_conventional_name!
              r2.add_association many_to_many_ass2
            end
          end

          # By default joins are given short names. When multiple joins conflict on name, we ask the relation to
          # disambiguate them
          schema.relations.each(&:disambiguate_conflicting_join_names!)

          schema.relations.each do |relation|
            relation.duplicate_join_association_names.each do |k, v|
              puts "AFTER DISAMBIGUATION #{relation} has #{v.count} m2m associations named #{k}"
            end
          end
        end

      end
    end
  end
end


