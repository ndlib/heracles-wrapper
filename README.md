# Heracles::Wrapper

[![Build Status](https://secure.travis-ci.org/ndlib/heracles-wrapper.png)](http://travis-ci.org/ndlib/heracles-wrapper)

API Wrapper for [Heracles](https://github.com/ndlib/heracles) workflow manager.

## Installation

Add this line to your application's Gemfile:

    gem 'heracles-wrapper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heracles-wrapper

Get your Heracles API key

Once installed in your application use rails generate:

    rails generate heracles:wrapper:install -k <API_KEY_FROM_HERACLES>

## Usage

    Heracles::Wrapper.service(
      :create_job,
      :workflow_name => <WORKFLOW_NAME>,
      :parameters => {
        :notification_url => 'http://google.com'
      }
    )

## Test Usage

    require 'heracles-wrapper/test_helper'

    describe YourObject do
      include Heracles::Wrapper::TestHelper
      let(:service) {
        Heracles::Wrapper.service(
          :create_job,
          :workflow_name => <WORKFLOW_NAME>,
          :parameters => {
            :notification_url => 'http://google.com'
          }
        )
      }

      it 'should wrap the API with failing calls' do
        with_heracles_service_failure_stub(:create_job, 'Failure') do
          lambda {
            service.call
          }.must_raise(Heracles::Wrapper::RequestFailure, /Failure/)
        end
      end

      it 'should wrap the API' do
        with_heracles_service_stub(:create_job) do
          service.call.job_id.must_be_kind_of Fixnum
        end
      end
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
