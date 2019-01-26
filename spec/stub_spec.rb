require "spec_helper"
require "rubocop"
require 'rubocop/rspec/support'
require 'support/rubocop_autocorrect'

module RuboCop
  module Cop
    module MochaToRSpec
      describe Stub do
        include RuboCop::RSpec::ExpectOffense

        DEFAULT_FILENAME = 'example.rb'.freeze

        subject(:cop) { described_class.new }

        it "allows rspec-mocks stubbing" do
          expect_no_offenses(<<-RUBY)
            foo = double
          RUBY
        end

        it do
          expect_offense(<<-RUBY)
            foo = stub
                  ^^^^ Use `double` (rspec-mocks) instead of `stub` (Mocha)
          RUBY
        end

        it do
          expect_offense(<<-RUBY)
            foo = stub(foo: :bar)
                  ^^^^^^^^^^^^^^^ Use `double` (rspec-mocks) instead of `stub` (Mocha)
          RUBY
        end

        include_examples 'autocorrect',
          'object = stub',
          'object = double'
        include_examples 'autocorrect',
          'object = stub(foo: :bar)',
          'object = double(foo: :bar)'
      end
    end
  end
end
