module Dart
  module NamingConventions
    module DirectAssociationHelpers

      # Returns true if this association has a conventional foreign key pointing to the given table_name
      def conventional_parent?(table_name)
        parent_table == table_name && conventional_foreign_key?
      end

      # Returns true if this association has a conventional primary key on the parent table
      def conventional_primary_key?
        primary_key == naming_conventions.conventional_primary_key
      end

      # Returns true if this association has a conventionally named foreign key based on the parent table name
      def conventional_foreign_key?
        parent_table == naming_conventions.parent_table_for(foreign_key)
      end
    end
  end
end
