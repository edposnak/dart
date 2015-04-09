module Dart
  class Association

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
