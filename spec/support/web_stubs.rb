module WebStubs

  def stub_api(method, path)
    ApiRequest.new(method, path)
  end

  class ApiRequest
    def initialize(method, path)
      @method = method
      @path = path
    end

    def to_return(code, body)
      url = "https://api.semaphoreci.com/v2#{@path}"

      WebMock.stub_request(@method, url).to_return(:status => code, :body => body.to_json)
    end
  end

end
