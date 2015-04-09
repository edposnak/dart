module Dart
  class DirectAssociation < Association
    ATTRIBUTES = [:child_table, :foreign_key, :parent_table, :primary_key]
    attr_reader *ATTRIBUTES

    # Constructs a DirectAssociation from the given attributes, which may be a Hash or an object that responds to
    # methods corresponding to ATTRIBUTES defined above
    # @param [Hash|respond_to?(:child_table, ...)] obj_or_hash
    def initialize(obj_or_hash)

      obj = obj_or_hash.is_a?(Hash) ? OpenStruct.new(obj_or_hash) : obj_or_hash
      @child_table  = obj.child_table.to_s.freeze or raise "No child table in #{obj_or_hash}"
      @foreign_key  = obj.foreign_key.to_s.freeze or raise "No foreign_key in #{obj_or_hash}"
      @parent_table = obj.parent_table.to_s.freeze or raise "No parent_table in #{obj_or_hash}"
      @primary_key  = obj.primary_key.to_s.freeze or raise "No primary_key in #{obj_or_hash}"
    end

    def eql?(other)
      ATTRIBUTES.all? { |f| send(f) == other.send(f) }
    end
    alias == eql?

    def hash
      ATTRIBUTES.map { |a| send(a) }.hash
    end

    def to_s
      "#{self.class} #{ATTRIBUTES.map { |a| "#{a}: #{send(a)}" }.join(', ')}"
    end

  end
end
