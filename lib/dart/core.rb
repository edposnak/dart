require 'ostruct'
require 'singleton'
require 'abstract_method'

require_relative 'version'
require_relative 'naming_conventions/abstract_base'

require_relative 'core/foreign_key_info'

require_relative 'core/association'
require_relative 'core/direct_association'
require_relative 'core/one_to_one_association'
require_relative 'core/many_to_one_association'
require_relative 'core/one_to_many_association'
require_relative 'core/many_to_many_association'

require_relative 'core/relation'
