require "spec_helper"
require "rubocop"
require "rubocop/cop/mocha_to_rspec/any_instance_returns"

module RuboCop
  module Cop
    module MochaToRSpec
      describe AnyInstanceReturns do
        include RuboCop::RSpec::ExpectOffense

        DEFAULT_FILENAME = 'example.rb'.freeze

        subject(:cop) { described_class.new }

        it "allows rspec-mocks 'allow_any_instance_of'" do
          expect_no_offenses(<<-RUBY)
            allow_any_instance_of(Object).to receive(:foo)
          RUBY
        end

        it "allows rspec-mocks 'expect_any_instance_of'" do
          expect_no_offenses(<<-RUBY)
            expect_any_instance_of(Object).to receive(:foo)
          RUBY
        end

        it do
          expect_offense(<<-RUBY)
            Object.any_instance.expects(:foo).returns(b)
                                              ^^^^^^^ Use `expect_any_instance_of(...)` (rspec-mocks) instead of `any_instance` (Mocha)
          RUBY
        end

        # expects, return a var
        include_examples 'autocorrect',
                         'Object.any_instance.expects(:foo).returns(b)',
                         'expect_any_instance_of(Object).to receive(:foo).and_return(b)'
        # stubs, return a var
        include_examples 'autocorrect',
                         'Object.any_instance.stubs(:foo).returns(b)',
                         'allow_any_instance_of(Object).to receive(:foo).and_return(b)'
        # stubs, return a symbol
        include_examples 'autocorrect',
                         'Object.any_instance.stubs(:foo).returns(:bar)',
                         'allow_any_instance_of(Object).to receive(:foo).and_return(:bar)'
        # stubs, return nil
        include_examples 'autocorrect',
                         'Object.any_instance.stubs(:foo).returns(:bar)',
                         'allow_any_instance_of(Object).to receive(:foo).and_return(:bar)'
      end
    end
  end
end
