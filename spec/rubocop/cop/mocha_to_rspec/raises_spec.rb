require "spec_helper"
require "rubocop"
require 'rubocop/rspec/support'
require 'support/rubocop_autocorrect'
require "rubocop/cop/mocha_to_rspec/raises"

module RuboCop
  module Cop
    module MochaToRSpec
      describe Raises do
        include RuboCop::RSpec::ExpectOffense

        DEFAULT_FILENAME = 'example.rb'.freeze

        subject(:cop) { described_class.new }

        specify do
          expect_no_offenses(<<-RUBY)
            allow(dbl).to receive(:foo).and_raise("boom")
          RUBY
        end

        specify do
          expect_offense(<<-RUBY)
            dbl.stubs(:foo).raises("boom")
                            ^^^^^^ Use `and_raise` (rspec-mocks) instead of `raises` (Mocha)
          RUBY
        end

        include_examples 'autocorrect',
          'dbl.stubs(:foo).raises("boom")',
          'dbl.stubs(:foo).and_raise("boom")'
      end
    end
  end
end
