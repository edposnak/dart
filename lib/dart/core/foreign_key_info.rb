ForeignKeyInfo = Struct.new :child_table, :foreign_key, :parent_table, :primary_key do
  module Constructors
    def from_hash(attrs)
      new(attrs[:child_table], attrs[:foreign_key], attrs[:parent_table], attrs[:primary_key])
    end
  end
  extend Constructors
end
