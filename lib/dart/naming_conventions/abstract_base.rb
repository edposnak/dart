module Dart
  module NamingConventions

    PUBLIC_API_METHODS = [:parent_table_for, :singular_association_name, :plural_association_name, :long_association_name, :conventional_join_table_names]

    class AbstractBase
      abstract_method :conventional_primary_key, :foreign_key_regex
      abstract_method :pluralize, :singularize

      # Returns the name of a possibly referenced table if the given possible_foreign_key follows the naming convention,
      # otherwise returns nil
      #
      # Examples:
      #   parent_table_for('group_id') => 'groups'
      #   parent_table_for('created_by') => nil
      #
      # @param [String|Symbol] possible_foreign_key name of the possibly referencing column
      # @return [String|NilClass] name of the possibly referenced table if found by convention
      #
      def parent_table_for(possible_foreign_key)
        pluralize singular_association_name(possible_foreign_key) if possible_foreign_key =~ foreign_key_regex
      end

      # Returns a many_to_one association name based on the given foreign_key according to the naming convention
      # Examples:
      #   to_association('group_id') => 'group'
      #   to_association('team_id') => 'team'
      #   to_association('created_by') => 'created_by'
      #
      def singular_association_name(foreign_key)
        if foreign_key =~ foreign_key_regex
          foreign_key[0...foreign_key.index(foreign_key_regex)]
        else
          foreign_key
        end
      end

      # Returns a one_to_many association name based on the given foreign_key according to the naming convention
      # Examples:
      #   to_association('group_id') => 'groups'
      #   to_association('team_id') => 'teams'
      #   to_association('created_by') => 'created_bies'
      #
      def plural_association_name(foreign_key)
        pluralize singular_association_name(foreign_key)
      end

      # Returns a long many_to_many association name based on the given join table and foreign_keys according to the
      # naming convention
      # Examples:
      #   long_association_name('topic_assignments', 'group_id', 'groups', 'user_id') => 'topic_assignment_users'
      #   long_association_name('broadcasts', 'created_by', 'users', 'item_id') => 'broadcast_created_by_items'
      #
      def long_association_name(join_table, left_key, left_table, right_key)
        left_key_qualifier = "_#{left_key}" if left_table != parent_table_for(left_key)
        "#{singularize(join_table)}#{left_key_qualifier}_#{plural_association_name(right_key)}"
      end

      # Returns unique singular and plural combinations of the given table names that would be used in constructing a
      # conventional join table name (assumes the given table_names are plural)
      def conventional_join_table_names(left_table_name, right_table_name)
        # TODO consider [left_table_name, pluralize(left_table_name), singularize(left_table_name)].uniq
        left_names  = [left_table_name, singularize(left_table_name)].uniq
        right_names = [right_table_name, singularize(right_table_name)].uniq

        (left_names.product(right_names) + right_names.product(left_names)).map { |t1, t2| "#{t1}_#{t2}" }
      end

    end
  end
end
