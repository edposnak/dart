require_relative 'naming_conventions/foreign_key_finder'

require_relative 'naming_conventions/relation_helpers'
require_relative 'naming_conventions/association_helpers'
require_relative 'naming_conventions/direct_association_helpers'
require_relative 'naming_conventions/many_to_many_association_helpers'
require_relative 'naming_conventions/many_to_one_association_helpers'
require_relative 'naming_conventions/one_to_many_association_helpers'

module Dart
  module NamingConventions

    # NamingConventions.instance must be set by the user of this module. It is normally a subclass of AbstractBase
    class << self
      attr_accessor :instance
    end
  end
end