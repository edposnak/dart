require 'sequel'

# Install the Sequel table based naming conventions and resolver
require_relative 'core'

require_relative 'reflection/abstract_resolver'

require_relative 'reflection/sequel/sequelizer'

require_relative 'reflection/sequel_table/foreign_key_finder'
require_relative 'reflection/sequel_table/schema'
require_relative 'reflection/sequel_table/resolver'
require_relative 'reflection/sequel_table/reflector'

# Reflector relies on some naming conventions to discover and name many_to_many associations from foreign keys
# has_direct_conventional_parent?      - to prevent creation of many_to_many when direct already exists
# disambiguate_conflicting_join_names! - to allow short names in most cases and only disambiguate in conflicting cases

# If/when we make the resolvers search for possible join tables only when a direct association doesn't exist, then
# we can probably decouple sequel table resolvers from naming conventions. However, naming conventions would be very
# useful to choose the best join association when multiple possibilities exist.

require_relative 'naming_conventions'
