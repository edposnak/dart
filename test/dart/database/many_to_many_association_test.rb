require_relative '../../test_helper'
require_relative '../../../lib/dart/database'
require_relative '../../../lib/dart/database/test_helpers'
require_relative '../../../lib/dart/reflection/sequel/naming_conventions' # install Sequel naming conventions

module Dart
  module Database
    class ManyToManyAssociationTest < Minitest::Test

      include Dart::Database::TestHelpers

      ##############################################################################################################
      # describe #disambiguate_name!

      def test_disambiguate_name_with_conventional_join_table
        join = many_to_many_ass many_to_one_ass(:groups_users, :user_id, :users, :id),
                                many_to_one_ass(:groups_users, :group_id, :groups, :id)
        join.disambiguate_name!
        assert_equal 'groups', join.name
      end

      def test_disambiguate_name_with_semi_conventional_join_table
        join = many_to_many_ass many_to_one_ass(:user_groups, :group_id, :groups, :id),
                                many_to_one_ass(:user_groups, :user_id, :users, :id)
        join.disambiguate_name!
        assert_equal 'users', join.name
      end

      def test_disambiguate_name_with_unconventional_join_table
        join = many_to_many_ass many_to_one_ass(:membership, :user_id, :users, :id),
                                many_to_one_ass(:membership, :group_id, :groups, :id)
        join.disambiguate_name!
        assert_equal 'membership_groups', join.name
      end

      def test_disambiguate_name_with_unconventional_left_foreign_key
        join = many_to_many_ass many_to_one_ass(:user_groups, :member_id, :users, :id),
                                many_to_one_ass(:user_groups, :groups_id, :groups, :id)
        join.disambiguate_name!
        assert_equal 'groups', join.name
      end

      def test_disambiguate_name_with_unconventional_right_foreign_key
        join = many_to_many_ass many_to_one_ass(:user_groups, :user_id, :users, :id),
                                many_to_one_ass(:user_groups, :team_id, :groups, :id)
        join.disambiguate_name!
        assert_equal 'teams', join.name
      end

      def test_disambiguate_name_with_unconventional_left_and_right_foreign_keys
        join = many_to_many_ass many_to_one_ass(:user_groups, :member_id, :users, :id),
                                many_to_one_ass(:user_groups, :team_id, :groups, :id)
        join.disambiguate_name!
        assert_equal 'teams', join.name
      end

      def test_disambiguate_name_with_unconventional_join_table_and_left_foreign_key
        join = many_to_many_ass many_to_one_ass(:membership, :member_id, :users, :id),
                                many_to_one_ass(:membership, :group_id, :items, :id)
        join.disambiguate_name!
        assert_equal 'membership_member_id_groups', join.name
      end

      def test_disambiguate_name_with_unconventional_join_table_and_right_foreign_key
        join = many_to_many_ass many_to_one_ass(:membership, :user_id, :users, :id),
                                many_to_one_ass(:membership, :team_id, :items, :id)
        join.disambiguate_name!
        assert_equal 'membership_teams', join.name
      end

      def test_disambiguate_name_with_unconventional_join_table_and_left_and_right_foreign_keys
        join = many_to_many_ass many_to_one_ass(:membership, :member_id, :users, :id),
                                many_to_one_ass(:membership, :team_id, :items, :id)
        join.disambiguate_name!
        assert_equal 'membership_member_id_teams', join.name
      end

    end
  end
end