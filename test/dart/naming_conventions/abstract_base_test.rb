require_relative '../../test_helper'
require_relative '../../../lib/dart/naming_conventions'
require_relative '../../../lib/dart/reflection/sequel/naming_conventions' # install Sequel naming conventions

module Dart
  module NamingConventions
    class AbstractBaseTest < Minitest::Test

      def subject
        NamingConventions.instance
      end

      def test_parent_table_for # (possible_foreign_key)
        assert_equal 'groups', subject.parent_table_for('group_id')
        assert_nil subject.parent_table_for('created_by')
      end

      def test_singular_association_name # (foreign_key)
        assert_equal 'group', subject.singular_association_name('group_id')
      end

      def test_plural_association_name # (foreign_key)
        assert_equal 'groups', subject.plural_association_name('group_id')
      end

      def test_long_association_name # (join_table, left_key, left_table, right_key)
        assert_equal 'topic_assignment_users', subject.long_association_name('topic_assignments', 'group_id', 'groups', 'user_id')
        assert_equal 'broadcast_created_by_items', subject.long_association_name('broadcasts', 'created_by', 'users', 'item_id')
      end

      def test_conventional_join_table_names # (left_table_name, right_table_name)
        expected = %w(groups_users group_users groups_user group_user users_groups user_groups users_group user_group)
        assert_equal expected.sort, subject.conventional_join_table_names('users', 'groups').sort
      end

    end
  end
end
