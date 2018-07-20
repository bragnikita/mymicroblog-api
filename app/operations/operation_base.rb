module Operations
  class OperationBase
    def initialize
      @called = false
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