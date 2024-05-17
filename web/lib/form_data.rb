# frozen_string_literal: true

class FormData
  def initialize(action:, data:)
    @uri = URI(action)
    @data = data
  end

  def send
    request = Net::HTTP::Post.new(@uri)
    request.set_form(@data, "multipart/form-data")

    Net::HTTP.start(@uri.hostname, @uri.port, use_ssl: true) do |http|
      response = http.request(request)

      raise StandardError, response unless successful_response?(response)
    end
  end

  private

  def successful_response?(response)
    code = response.code.to_i
    code.in?(200..299)
  end
end
