module Dart
  module NamingConventions
    module RelationHelpers

      # Returns true if this relation has a many_to_one association with the given table_name
      # @param [String] table_name
      def has_direct_conventional_parent?(table_name)
        parent_associations.any? { |a| a.conventional_parent?(table_name) }
      end

      # Finds joins with the same name and marks all but the conventional one as requiring a long name.
      #
      def disambiguate_conflicting_join_names!
        # Corner case problem: if the schema changes and a conventional join table is added, then what was formerly
        # foo many_to_many: :bars  join_table: poop_stinks, will need to be (manually) changed to something like
        # foo many_to_many: :poop_stink_bars, class: :Bar,  join_table: poop_stinks
        # and a request for foo.bars will now return bars from the foo_bars join table instead of the poop_stinks join
        # table. Making all non-conventional joins have long names is worse since in most cases (80/20) the "real"
        # join is just the existing unconventionally named table.
        # many_to_many :bars seems better for a vast majority of joins that are not conventional.

        duplicate_join_association_names.each do |_, join_associations|
          join_associations.each { |join| join.disambiguate_name! }
        end
      end

      # Returns a Hash of ass_name => number of copies for all duplicated join associations
      def duplicate_join_association_names
        join_associations.group_by(&:name).select { |name, join_associations| join_associations.count > 1 }
      end

      # Returns pairs of many_to_one associations that could make up a join through this relation
      # @return [Array<[String,String]]
      def possible_join_pairs
        parent_associations.combination(2).to_a
      end

    end
  end
end
