module Dart
  module Reflection
    class AbstractResolver
      abstract_method :build_from_association, :association_for, :column_for, :table_name
      abstract_method :default_where_sql
    end
  end
end
