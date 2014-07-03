module Requests
  module JsonHelpers
    def json
      if response.body.blank?
        @json ||= {}
      else
        @json ||= JSON.parse(response.body)
      end
    end
  end
end