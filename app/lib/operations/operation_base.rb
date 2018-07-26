module Operations
  class OperationBase
    include ActiveModel::Model

    def initialize(attributes = {})
      assign_attributes attributes
      @called = false
      super(attributes)
    end

    def call
      return self if @called
      @called = true
      @result = doWork
      self
    end

    def result
      @result
    end

    protected

    def doWork

    end

  end

  class SelectorBase
    include ActiveModel::Model
    def call
      @result = doWork
      self
    end
    def result
      @result
    end
  end
end