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

      # Helpers


      QUERY_OPTIONS = [:where, :order, :limit]
      QUERY_OPTION_REGEXS = [/WHERE\s*(?<where>.*)/, /ORDER\s+BY\s*(?<order>.*)/, /LIMIT\s*(?<limit>.*)/]

      # Returns parts of the given sql_string in a hash of the form {where: ..., order: ..., limit: ...}
      def scope_hash_from(sql_string)
        # TODO: cleanup - this is some of the ugliest code I've ever written
        result = {}
        re_start_pairs = QUERY_OPTION_REGEXS.map {|re| [re, sql_string =~ re]}.reject {|_, i| i.nil?}.sort_by {|_, i| i}
        re_start_pairs.each_with_index do |re_start, i|
          re, start_index = re_start
          end_index = -1
          if next_match = re_start_pairs[i+1]
            end_index = next_match[1]-1
          end
          sql_string[start_index..end_index] =~ re
          QUERY_OPTIONS.each {|o| result[o] = $~[o].strip if ($~[o] rescue nil)}
        end

        result
      end

    end
  end
end