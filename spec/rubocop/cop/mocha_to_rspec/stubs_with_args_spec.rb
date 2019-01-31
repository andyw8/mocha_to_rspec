require "spec_helper"
require "rubocop"
require 'rubocop/rspec/support'
require "rubocop/cop/mocha_to_rspec/stubs_with_args"

module RuboCop
  module Cop
    module MochaToRSpec
      describe StubsWithArgs, irregular: true do
        include RuboCop::RSpec::ExpectOffense

        DEFAULT_FILENAME = 'example.rb'.freeze

        subject(:cop) { described_class.new }

        it "allows rspec-mocks stubbing using `with`" do
          expect_no_offenses(<<-RUBY)
            Object.stubs(:foo)
            allow(Object).to receive(:foo).with(:bar)
          RUBY
        end

        specify do
          expect_offense(<<-RUBY)
            Object.stubs(:foo).with(:bar)
                               ^^^^ Use `allow/expect(Object).to receive(...).with(...)` (rspec-mocks) instead of `Object.stubs/expects(...).with(...)` (Mocha)
          RUBY
        end

        specify do
          expect_offense(<<-RUBY)
            Object.stubs(:foo).with(:bar, :baz)
                               ^^^^ Use `allow/expect(Object).to receive(...).with(...)` (rspec-mocks) instead of `Object.stubs/expects(...).with(...)` (Mocha)
          RUBY
        end

        specify do
          expect_offense(<<-RUBY)
            Object.expects(:foo).with(:bar)
                                 ^^^^ Use `allow/expect(Object).to receive(...).with(...)` (rspec-mocks) instead of `Object.stubs/expects(...).with(...)` (Mocha)
          RUBY
        end


        include_examples 'autocorrect',
          'object.stubs(:foo).with(:bar)', # variable
          'allow(object).to receive(:foo).with(:bar)'
        include_examples 'autocorrect',
          'Object.stubs(:foo).with(:bar)', # class
          'allow(Object).to receive(:foo).with(:bar)'
        include_examples 'autocorrect',
          'Object.stubs(:fop).with(:bar)',
          'allow(Object).to receive(:fop).with(:bar)'
        include_examples 'autocorrect',
          'Object.stubs(:foo).with("bar")',
          'allow(Object).to receive(:foo).with("bar")'
        include_examples 'autocorrect',
          'Object.expects(:foo).with(:bar)',
          'expect(Object).to receive(:foo).with(:bar)'
        include_examples 'autocorrect',
          'Object.expects(:foo).with(:bar, :baz)',
          'expect(Object).to receive(:foo).with(:bar, :baz)'
        include_examples 'autocorrect',
          'Widget.expects(:foo).with(:bar, :baz)',
          'expect(Widget).to receive(:foo).with(:bar, :baz)'
        include_examples 'autocorrect',
          'Namespace::Object.expects(:foo).with(:bar, :baz)',
          'expect(Namespace::Object).to receive(:foo).with(:bar, :baz)'
        include_examples 'autocorrect',
          'row.expects(value_method).with(arg).and_return(return_value)',
          'expect(row).to receive(value_method).with(arg).and_return(return_value)'
      end
    end
  end
end
