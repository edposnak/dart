module Dart
  module NamingConventions
    class ManyToManyAssociation < Dart::ManyToManyAssociation
      include AssociationHelpers

      def initialize(*)
        super
        set_conventional_name!
      end

      # Returns the name of a referenced association according to the naming convention
      #
      # @return [String] the name of the referenced association
      #
      def conventional_name
        # just return e.g. 'groups' if right_ass.foreign_key is group_id
        naming_conventions.plural_association_name(right_ass.foreign_key)
      end

      def name_is_conventional?
        name == associated_table
      end

      def name_and_right_foreign_key_are_conventional?
        # name == associated_table == naming_conventions.parent_table_for(right_ass.foreign_key)
        name_is_conventional? && right_foreign_key_is_conventional?
      end

      def left_foreign_key_is_conventional?
        left_ass.conventional_foreign_key?
      end

      def right_foreign_key_is_conventional?
        right_ass.conventional_foreign_key?
      end

      # forces long-form name to disambiguate from other joins to same association, where short-form name is the same
      def disambiguate_name!
        unless is_semi_conventional_join_table?
          # add a foreign_key disambiguator when the key referencing me is unconventional
          set_name! naming_conventions.long_association_name(join_table, left_ass.foreign_key, left_ass.parent_table, right_ass.foreign_key)
        end
      end

      private

      # Returns true if the table joining t1 and t2 is semi-conventional, i.e. some variation of t1_t2 or t2_t1, for
      # plural or singular forms of t1 and t2
      def is_semi_conventional_join_table?
        @semi_conventional_join_table ||= begin
          naming_conventions.conventional_join_table_names(left_ass.parent_table, right_ass.parent_table).include?(join_table)
        end
      end

    end
  end
end
