require "spec_helper"
require "rubocop"
require 'rubocop/rspec/support'

RSpec.shared_examples 'autocorrect' do |original, corrected|
  it "autocorrects `#{original}` to `#{corrected}`" do
    autocorrected = autocorrect_source(original, 'spec/foo_spec.rb')

    expect(autocorrected).to eql(corrected)
  end
end

module RuboCop
  module Cop
    module MochaToRSpec
      describe StubsWithHash do
        include RuboCop::RSpec::ExpectOffense

        DEFAULT_FILENAME = 'example.rb'.freeze

        subject(:cop) { described_class.new }

        it "allows rspec-mocks stubbing" do
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
