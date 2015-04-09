require_relative 'naming_conventions/foreign_key_finder'

require_relative 'naming_conventions/relation_helpers'
require_relative 'naming_conventions/association_helpers'
require_relative 'naming_conventions/direct_association_helpers'
require_relative 'naming_conventions/many_to_many_association'
require_relative 'naming_conventions/many_to_one_association'
require_relative 'naming_conventions/one_to_many_association'

# TODO replace with decorators/subclasses
require 'sequel'
module Dart

  naming_conventions = NamingConventions::AbstractBase.instance
  naming_conventions.configure(conventional_primary_key: 'id', foreign_key_regex: /_id$/)
  naming_conventions.extend(::Sequel::Inflections) # for pluralize and singularize

  Relation.send(:include, NamingConventions::RelationHelpers)
end
