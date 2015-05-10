require_relative '../../test_helper'
require 'dart/sequel_model_reflection'

module Dart
  module Reflection
    class OrmModelResolverTest < Minitest::Test

      # describe #scope_hash_from

      def subject
        model_class = OpenStruct.new
        OrmModelResolver.new(model_class)
      end

      def test_scope_hash_from_select_only
        sql = "SELECT * FROM users"
        actual = subject.scope_hash_from(sql)
        assert_nil actual[:where]
        assert_nil actual[:order]
        assert_nil actual[:limit]
      end

      def test_scope_hash_from_where
        expected_where = "occupation = 'Brewer' AND first_name = 'Samuel'"
        sql = "SELECT * FROM users WHERE #{expected_where}"
        actual = subject.scope_hash_from(sql)
        assert_equal expected_where, actual[:where]
        assert_nil actual[:order]
        assert_nil actual[:limit]
      end

      def test_scope_hash_from_where_order
        expected_where = "occupation = 'Brewer' AND first_name = 'Samuel'"
        expected_order = '"users"."last_name" ASC'
        sql = "SELECT * FROM users WHERE #{expected_where} ORDER BY #{expected_order}"
        actual = subject.scope_hash_from(sql)
        assert_equal expected_where, actual[:where]
        assert_equal expected_order, actual[:order]
        assert_nil actual[:limit]
      end

      def test_scope_hash_from_where_order_limit
        expected_where = "occupation = 'Brewer' AND first_name = 'Samuel'"
        expected_order = '"users"."last_name" ASC'
        expected_limit = '5'
        sql = "SELECT * FROM users WHERE #{expected_where} ORDER BY #{expected_order} LIMIT #{expected_limit}"
        actual = subject.scope_hash_from(sql)
        assert_equal expected_where, actual[:where]
        assert_equal expected_order, actual[:order]
        assert_equal expected_limit, actual[:limit]
      end

      def test_scope_hash_from_order_limit
        expected_order = '"users"."last_name" ASC'
        expected_limit = '5'
        sql = "SELECT * FROM users ORDER BY #{expected_order} LIMIT #{expected_limit}"
        actual = subject.scope_hash_from(sql)
        assert_nil actual[:where]
        assert_equal expected_order, actual[:order]
        assert_equal expected_limit, actual[:limit]
      end


    end
  end
end
