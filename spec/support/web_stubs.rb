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

    def to_return(code, body, headers = {})
      stub = WebMock.stub_request(@method, /.*semaphoreci.com\/v2#{@path}.*/)
      stub = stub.with(:body => @request_body.to_json) if @request_body

      stub.to_return(:status => code, :body => body.to_json, :headers => headers)
    end
  end

end
