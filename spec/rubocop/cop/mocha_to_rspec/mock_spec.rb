require "rubocop/cop/mocha_to_rspec/at_least"

module RuboCop
  module Cop
    module MochaToRSpec
      describe AtLeast do
        include RuboCop::RSpec::ExpectOffense

        DEFAULT_FILENAME = 'example.rb'.freeze

        subject(:cop) { described_class.new }

        specify do
          expect_offense(<<-RUBY)
            obj.expects(:foo).at_least_once
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `at_least(:once)` (rspec-mocks) instead of `at_least_once` (Mocha)
          RUBY
        end

        include_examples 'autocorrect',
                         'obj.expects(:foo).at_least_once',
                         'obj.expects(:foo).at_least(:once)'
      end
    end
  end
end
