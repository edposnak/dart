module Dart
  class ManyToManyAssociation < Association

    attr_reader :left_ass, :right_ass
    protected :left_ass, :right_ass

    # for an m2m association on users we'd pass in:
    #   left_ass:    badge_users.user_id -> users.id
    #   right_ass: badge_users.badge_id -> badges.id
    # =>
    #   many_to_many :badges, join_table: :badge_users

    def initialize(left_ass, right_ass)
      @left_ass, @right_ass = left_ass, right_ass
    end

    def join_associations
      [left_ass, right_ass]
    end

    def type
      MANY_TO_MANY_TYPE
    end

    def associated_table
      right_ass.parent_table
    end

    def join_table
      right_ass.child_table
    end

    def left_foreign_key
      left_ass.foreign_key
    end

    def right_foreign_key
      right_ass.foreign_key
    end

    def eql?(other)
      join_associations.eql? other.join_associations
    end
    alias == eql?

    def hash
      join_associations.hash
    end

    def to_s
      "#{self.class}\n    left:#{left_ass}\n    right:#{right_ass}"
    end

  end
end
