module Operations
  class OperationBase

    def call
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
end