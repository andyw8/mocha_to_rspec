require "spec_helper"
require "rubocop"
require 'rubocop/rspec/support'
require 'support/rubocop_autocorrect'
require "rubocop/cop/mocha_to_rspec/stubs_with_no_return"

module RuboCop
  module Cop
    module MochaToRSpec
      # FIXME this is a bad name since would also apply to eg borrower.stubs(:work_phone).returns("(416) 555-1234")
      describe StubsWithNoReturn, irregular: true do
        include RuboCop::RSpec::ExpectOffense

        DEFAULT_FILENAME = 'example.rb'.freeze

        subject(:cop) { described_class.new }

        it "allows rspec-mocks stubbing" do
          expect_no_offenses(<<-RUBY)
            allow(Object).to receive(:foo)
          RUBY
        end

# % ruby-parse -e 'Object.any_instance.stubs(:foo)'
# (send
#   (send
#     (const nil :Object) :any_instance) :stubs (sym :foo))
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

# (send
#   (const nil :Object) :stubs
#   (sym :foo))
        # handled by stubs with hash
        it do
          expect_no_offenses(<<-RUBY)
            Object.stubs(foo: :bar)
          RUBY
        end

        it do
          expect_offense(<<-RUBY)
            Object.stubs(:foo)
            ^^^^^^^^^^^^^^^^^^ Use `allow(...).to receive(...)` (rspec-mocks) instead of `stubs` (Mocha)
          RUBY
        end

        it do
          expect_offense(<<-RUBY)
            Object.stubs(:foo).and_returns(:bar)
            ^^^^^^^^^^^^^^^^^^ Use `allow(...).to receive(...)` (rspec-mocks) instead of `stubs` (Mocha)
          RUBY
        end

        it do
          expect_offense(<<-RUBY)
            object.stubs(:foo).and_returns(:bar)
            ^^^^^^^^^^^^^^^^^^ Use `allow(...).to receive(...)` (rspec-mocks) instead of `stubs` (Mocha)
          RUBY
        end

# (send
#   (send
#     (send nil :loan) :borrower) :stubs
#   (sym :work_phone))
        it do
          expect_offense(<<-RUBY)
            loan.borrower.stubs(:work_phone)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `allow(...).to receive(...)` (rspec-mocks) instead of `stubs` (Mocha)
          RUBY
        end

        it do
          expect_offense(<<-RUBY)
            Object.stubs(:foo).and_returns(:bar)
            ^^^^^^^^^^^^^^^^^^ Use `allow(...).to receive(...)` (rspec-mocks) instead of `stubs` (Mocha)
          RUBY
        end
          include_examples 'autocorrect',
            'Object.stubs(:foo)',
            'allow(Object).to receive(:foo)'
          include_examples 'autocorrect',
            'loan.borrower.stubs(:work_phone)',
            'allow(loan.borrower).to receive(:work_phone)'
      end
    end
  end
end

# % ruby-parse -e 'Object.stubs(:foo).returns(:bar)'
# (send
#   (send
#     (const nil :Object) :stubs
#     (sym :foo)) :returns
#   (sym :bar)
# )
#
# > node.children.first
#  => s(:send,
#       s(:const, nil, :Object),
#       :stubs,
#       s(:sym, :foo)
#      )
