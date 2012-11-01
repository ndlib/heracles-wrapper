module Heracles
  module Wrapper
    HERACLES_BASE_URL = 'https://heracles.library.nd.edu'.freeze
    class Config
      attr_accessor :api_key
      def initialize
        yield(self) if block_given?
      end
      def heracles_base_url
        Heracles::Wrapper::HERACLES_BASE_URL
      end
    end
  end
end

