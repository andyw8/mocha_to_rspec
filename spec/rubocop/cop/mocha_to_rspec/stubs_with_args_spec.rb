require "spec_helper"
require "rubocop"
require 'rubocop/rspec/support'
require "rubocop/cop/mocha_to_rspec/stubs_with_args"
require "support/rubocop_autocorrect"

module RuboCop
  module Cop
    module MochaToRSpec
      describe StubsWithArgs, irregular: true do
        include RuboCop::RSpec::ExpectOffense

        DEFAULT_FILENAME = 'example.rb'.freeze

        subject(:cop) { described_class.new }

        it "ignores if already using rspec-mocks syntax" do
          expect_no_offenses(<<-RUBY)
            allow(Object).to receive(:foo).with(:bar).and_return(z)
          RUBY
        end

        it "allows if stubbing using a hash" do
          expect_no_offenses(<<-RUBY)
            Object.stubs(foo: :foz).returns(z)
          RUBY
        end

        specify do
          expect_offense(<<-RUBY)
            object.stubs(:foo).with(:bar).returns(:z)
                                          ^^^^^^^ Use `allow/expect(object).to receive(...).with(...)` (rspec-mocks) instead of `object.stubs/expects(...).with(...)` (Mocha)
          RUBY
        end

        specify do
          expect_offense(<<-RUBY)
            Object.stubs(:foo).with(:bar, :baz).returns(:z)
                                                ^^^^^^^ Use `allow/expect(object).to receive(...).with(...)` (rspec-mocks) instead of `object.stubs/expects(...).with(...)` (Mocha)
          RUBY
        end

        specify do
          expect_offense(<<-RUBY)
            Object.expects(:foo).with(:bar).returns(:z)
                                            ^^^^^^^ Use `allow/expect(object).to receive(...).with(...)` (rspec-mocks) instead of `object.stubs/expects(...).with(...)` (Mocha)
          RUBY
        end

        include_examples 'autocorrect',
          'object.stubs(:foo).with(:bar).returns(:z)', # variable
          'allow(object).to receive(:foo).with(:bar).and_return(:z)'
        include_examples 'autocorrect',
          'Object.stubs(:foo).with(:bar).returns(:z)', # class
          'allow(Object).to receive(:foo).with(:bar).and_return(:z)'
        include_examples 'autocorrect',
          'Object.stubs(:fop).with(:bar).returns(:z)',
          'allow(Object).to receive(:fop).with(:bar).and_return(:z)'
        include_examples 'autocorrect',
          'Object.stubs(:foo).with("bar").returns(:z)',
          'allow(Object).to receive(:foo).with("bar").and_return(:z)'
        include_examples 'autocorrect',
          'Object.expects(:foo).with(:bar).returns(:z)',
          'expect(Object).to receive(:foo).with(:bar).and_return(:z)'
        include_examples 'autocorrect',
          'Object.expects(:foo).with(:bar, :baz).returns(:z)',
          'expect(Object).to receive(:foo).with(:bar, :baz).and_return(:z)'
        include_examples 'autocorrect',
          'Widget.expects(:foo).with(:bar, :baz).returns(:z)',
          'expect(Widget).to receive(:foo).with(:bar, :baz).and_return(:z)'
        include_examples 'autocorrect',
          'Namespace::Object.expects(:foo).with(:bar, :baz).returns(:z)',
          'expect(Namespace::Object).to receive(:foo).with(:bar, :baz).and_return(:z)'
        include_examples 'autocorrect',
          'row.expects(value_method).with(arg).returns(return_value)',
          'expect(row).to receive(value_method).with(arg).and_return(return_value)'
      end
    end
  end
end
