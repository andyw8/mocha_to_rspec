require "spec_helper"
require "rubocop"
require 'rubocop/rspec/support'
require "rubocop/cop/mocha_to_rspec/stubs_with_no_args"

module RuboCop
  module Cop
    module MochaToRSpec
      describe StubsWithNoArgs do
        include RuboCop::RSpec::ExpectOffense

        DEFAULT_FILENAME = 'example.rb'.freeze

        subject(:cop) { described_class.new }

        it "allows rspec-mocks stubbing using `with`" do
          expect_no_offenses(<<-RUBY)
            Object.stubs(:foo)
            allow(Object).to receive(:foo).and_return(:bar)
          RUBY
        end
        it "ignores any_instance" do
          expect_no_offenses(<<-RUBY)
            Borrower.any_instance.stubs(:idv_response).returns(nil)
          RUBY
        end

        specify do
          expect_offense(<<-RUBY)
            Object.stubs(:foo).returns(:bar)
                               ^^^^^^^ Use `allow/expect(Object).to receive(...).and_return(...)` (rspec-mocks) instead of `Object.stubs/expects(...).returns(...)` (Mocha)
          RUBY
        end

        specify do
          expect_offense(<<-RUBY)
            Object.stubs(:foo).returns(:bar)
                               ^^^^^^^ Use `allow/expect(Object).to receive(...).and_return(...)` (rspec-mocks) instead of `Object.stubs/expects(...).returns(...)` (Mocha)
          RUBY
        end

        specify do
          expect_offense(<<-RUBY)
            Object.expects(:foo).returns(:bar)
                                 ^^^^^^^ Use `allow/expect(Object).to receive(...).and_return(...)` (rspec-mocks) instead of `Object.stubs/expects(...).returns(...)` (Mocha)
          RUBY
        end


        include_examples 'autocorrect',
                         'Object.stubs(:foo).returns(:bar)',
                         'allow(Object).to receive(:foo).and_return(:bar)'
        include_examples 'autocorrect',
                         'Object.stubs(:fop).returns(:bar)',
                         'allow(Object).to receive(:fop).and_return(:bar)'
        include_examples 'autocorrect',
                         'Object.stubs(:foo).returns("bar")',
                         'allow(Object).to receive(:foo).and_return("bar")'
        include_examples 'autocorrect',
                         'Object.expects(:foo).returns(:bar)',
                         'expect(Object).to receive(:foo).and_return(:bar)'
        include_examples 'autocorrect',
                         'Object.expects(:foo).returns(:bar, :baz)',
                         'expect(Object).to receive(:foo).and_return(:bar, :baz)'
        include_examples 'autocorrect',
                         'Widget.expects(:foo).returns(:bar, :baz)',
                         'expect(Widget).to receive(:foo).and_return(:bar, :baz)'
        include_examples 'autocorrect',
                         'Namespace::Object.expects(:foo).returns(:bar, :baz)',
                         'expect(Namespace::Object).to receive(:foo).and_return(:bar, :baz)'
        include_examples 'autocorrect',
                         'bucket.expects(attr).returns([])',
                         'expect(bucket).to receive(attr).and_return([])'
      end
    end
  end
end
