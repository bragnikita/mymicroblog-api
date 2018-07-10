module Helpers
  module RequestHelpers

    def getBody
      JSON.parse(response.body, :symbolize_names => true)
    end

    def login(username = 'admin')
      allow_any_instance_of(ApplicationController).to receive(:authenticate).and_return(username)
    end

    def logout
      allow_any_instance_of(ApplicationController).to receive(:authenticate).and_return(nil)
    end
  end
end