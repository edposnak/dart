module Dart
  module Reflection
    class OrmModelResolver < AbstractResolver

      abstract_method :build_association, :has_column?, :reflection_from

      attr_reader :this_model_class
      private :this_model_class

      def initialize(model_class)
        @this_model_class = model_class
      end

      def build_from_association(association)
        self.class.new(association.model_class)
      end

      # Returns the association with the given ass_name or nil if one does not exist
      # @param [String] ass_name
      # @return [Association]
      def association_for(ass_name)
        if ass_reflection = reflection_from(ass_name)
          build_association(ass_reflection)
        end
      end

      # Returns the column with the given col_name or nil if one does not exist
      # @param [String] col_name
      # @return [String]
      def column_for(col_name)
        col_name if has_column?(col_name)
      end

      def table_name
        this_model_class.table_name.to_s
      end


    end
  end
end