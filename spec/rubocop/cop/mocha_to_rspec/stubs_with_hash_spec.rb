require "spec_helper"
require "rubocop"
require 'rubocop/rspec/support'
require "rubocop/cop/mocha_to_rspec/stubs_with_hash"

module RuboCop
  module Cop
    module MochaToRSpec
      describe StubsWithHash, irregular: true do
        include RuboCop::RSpec::ExpectOffense

        DEFAULT_FILENAME = 'example.rb'.freeze

        subject(:cop) { described_class.new }

        it "ignores if arg is not a hash" do
          expect_no_offenses(<<-RUBY)
            Object.stubs(:foo)
          RUBY
        end

        it "..." do
          expect_no_offenses(<<-RUBY)
            Object.any_instance.stubs(:foo)

          RUBY
        end
        it "..." do
          expect_no_offenses(<<-RUBY)
            Purchase.any_instance.stubs(lender_transfer_date: Date.parse("2017-01-15").end_of_day)
          RUBY
        end

        it do
          expect_offense(<<-RUBY)
            Object.stubs(foo: :bar)
                   ^^^^^ Use `allow(...).to receive(...).and_return(...)` or `allow(...).to receive_messages` (rspec-mocks) instead of `stubs` (Mocha)
          RUBY
        end

        it do
          expect_offense(<<-RUBY)
            Object.stubs(foo: :bar, baz: :bat)
                   ^^^^^ Use `allow(...).to receive(...).and_return(...)` or `allow(...).to receive_messages` (rspec-mocks) instead of `stubs` (Mocha)
          RUBY
        end

        include_examples 'autocorrect',
          'Object.stubs(foo: :bar)',
          'allow(Object).to receive(:foo).and_return(:bar)'
        include_examples 'autocorrect',
          'object.stubs(foo: :bar)',
          'allow(object).to receive(:foo).and_return(:bar)'
        include_examples 'autocorrect',
          'Object.stubs(foo: "bar")',
          'allow(Object).to receive(:foo).and_return("bar")'
        include_examples 'autocorrect',
          'Object.stubs(foo: "bar", bat: "baz")',
          'allow(Object).to receive_messages(foo: "bar", bat: "baz")'
        include_examples 'autocorrect',
          'Object.stubs("foo" => "bar", "bat" => "baz")',
          'allow(Object).to receive_messages("foo" => "bar", "bat" => "baz")'
        include_examples 'autocorrect',
          'Foo::Object.stubs("foo" => "bar", "bat" => "baz")',
          'allow(Foo::Object).to receive_messages("foo" => "bar", "bat" => "baz")'
      end
    end
  end
end
