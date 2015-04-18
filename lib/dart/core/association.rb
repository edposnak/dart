module Dart
  class Association

    ONE_TO_MANY_TYPE = :one_to_many
    MANY_TO_ONE_TYPE = :many_to_one
    MANY_TO_MANY_TYPE = :many_to_many

    # used by some implementations to store the associated ORM model class
    attr_accessor :model_class

    abstract_method :type, :associated_table

    attr_reader :name

    # @param [String|Symbol] ass_name
    def set_name!(ass_name)
      @name = ass_name.to_s
    end

  end
end
