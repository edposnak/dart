module Dart
  module Reflection
    class AbstractResolver
      abstract_method :association_for, :column_for, :table_name

      def to_s
        "#{self.class} table_name=#{table_name}"
      end
    end
  end
end
