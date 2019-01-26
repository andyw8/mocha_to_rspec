require "spec_helper"
require "rubocop"
require 'rubocop/rspec/support'
require 'support/rubocop_autocorrect'

module RuboCop
  module Cop
    module MochaToRSpec
      describe AndReturn do
        include RuboCop::RSpec::ExpectOffense

        DEFAULT_FILENAME = 'example.rb'.freeze

        subject(:cop) { described_class.new }

        it "allows rspec-mocks stubbing" do
          expect_no_offenses(<<-RUBY)
            Object.stubs(:foo).and_return(:bar)
          RUBY
        end

        it do
          expect_offense(<<-RUBY)
            Object.stubs(:foo).returns(:bar)
                               ^^^^^^^ Use `and_return` (rspec-mocks) instead of `returns` (Mocha)
          RUBY
        end

        it do
          expect_offense(<<-RUBY)
            Object.stubs(:foo).returns("bar")
                               ^^^^^^^ Use `and_return` (rspec-mocks) instead of `returns` (Mocha)
          RUBY
        end

        include_examples 'autocorrect',
          'Object.stubs(:foo).returns(:bar)',
          'Object.stubs(:foo).and_return(:bar)'
        include_examples 'autocorrect',
          'Object.stubs(:foo).returns("bar")',
          'Object.stubs(:foo).and_return("bar")'
        include_examples 'autocorrect',
          'Foo.any_instance.stubs(:required?).returns(false)',
          'Foo.any_instance.stubs(:required?).and_return(false)'
        include_examples 'autocorrect',
          'Object.stubs(:foo).returns()',
          'Object.stubs(:foo)'
      end
    end
  end
end
