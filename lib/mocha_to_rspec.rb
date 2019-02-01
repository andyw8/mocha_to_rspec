require "rubocop"

require "rubocop/cop/mocha_to_rspec/version"
require "rubocop/cop/mocha_to_rspec/any_instance"
require "rubocop/cop/mocha_to_rspec/any_instance_returns"
require "rubocop/cop/mocha_to_rspec/mock"
require "rubocop/cop/mocha_to_rspec/raises"
require "rubocop/cop/mocha_to_rspec/stub"
require "rubocop/cop/mocha_to_rspec/stubs_with_args"
require "rubocop/cop/mocha_to_rspec/stubs_with_hash"
require "rubocop/cop/mocha_to_rspec/stubs_with_no_args"
require "rubocop/cop/mocha_to_rspec/stubs_with_no_return"
require "active_support/core_ext/string/inflections" # for `camelize`

module MochaToRSpec
  # Your code goes here...
  def self.cop_list
    Dir["#{File.dirname(__FILE__)}/rubocop/cop/mocha_to_rspec/*"].map do |filename|
      filename
        .split("/")
        .last
        .gsub(".rb", '')
        .camelize
    end.reject { |x| x == "Version" }
        .map { |x| "#{MochaToRSpec}/#{x}" }
  end
end
