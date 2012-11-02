module Heracles
  module Wrapper
    HERACLES_BASE_URL = 'https://heracles.library.nd.edu'.freeze
    class Config
      attr_accessor :api_key
      def initialize
        yield(self) if block_given?
      end

      attr_writer :heracles_base_url
      def heracles_base_url
        @heracles_base_url || Heracles::Wrapper::HERACLES_BASE_URL
      end
    end
  end
end

