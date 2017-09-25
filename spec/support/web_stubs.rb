module WebStubs

  def stub_api(method, path, request_body = nil)
    ApiRequest.new(method, path, request_body)
  end

  class ApiRequest
    def initialize(method, path, request_body)
      @method = method
      @path = path
      @request_body = request_body
    end

    def to_return(code, body)
      url = "https://api.semaphoreci.com/v2#{@path}"

      stub = WebMock.stub_request(@method, url)
      stub = stub.with(:body => @request_body.to_json) if @request_body

      stub.to_return(:status => code, :body => body.to_json)
    end
  end

end
