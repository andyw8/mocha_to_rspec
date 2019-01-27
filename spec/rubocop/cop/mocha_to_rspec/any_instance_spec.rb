require "spec_helper"
require "rubocop"
require "rubocop/cop/mocha_to_rspec/any_instance"

module RuboCop
  module Cop
    module MochaToRSpec
      describe AnyInstance, irregular: true do
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
          # TODO this should be allow
          expect_offense(<<-RUBY)
            Object.any_instance.stubs(:foo)
                                ^^^^^ Use `expect_any_instance_of(...)` (rspec-mocks) instead of `any_instance` (Mocha)
          RUBY
        end

        it do
          expect_offense(<<-RUBY)
            Object.any_instance.expects(:foo)
                                ^^^^^^^ Use `expect_any_instance_of(...)` (rspec-mocks) instead of `any_instance` (Mocha)
          RUBY
        end

        include_examples 'autocorrect',
          'Object.any_instance.expects(:foo)',
          'expect_any_instance_of(Object).to receive(:foo)'
        include_examples 'autocorrect',
          'Object.any_instance.stubs(:foo)',
          'allow_any_instance_of(Object).to receive(:foo)'
        include_examples 'autocorrect',
          'Object.any_instance.stubs(:foo).returns(:bar)',
          'allow_any_instance_of(Object).to receive(:foo).returns(:bar)'
        include_examples 'autocorrect',
          'Borrower.any_instance.stubs(:idv_response).returns(nil)',
          'allow_any_instance_of(Borrower).to receive(:idv_response).returns(nil)'
        include_examples 'autocorrect',
          'Purchase.any_instance.stubs(lender_transfered: true)',
          'allow_any_instance_of(Purchase).to receive(lender_transfered: true)'
        include_examples 'autocorrect',
          'Purchase.any_instance.stubs(lender_transfer_date: Date.parse("2017-01-15").end_of_day)',
          'allow_any_instance_of(Purchase).to receive(lender_transfer_date: Date.parse("2017-01-15").end_of_day)'
      end
    end
  end
end
