require "rubocop/cop/mocha_to_rspec/mock"

module RuboCop
  module Cop
    module MochaToRSpec
      describe Mock, irregular: true do
        include RuboCop::RSpec::ExpectOffense

        DEFAULT_FILENAME = 'example.rb'.freeze

        subject(:cop) { described_class.new }

        it "allows rspec-mocks mocking" do
          expect_no_offenses(<<-RUBY)
            foo = double
          RUBY
        end

        it do
          expect_offense(<<-RUBY)
            foo = mock
                  ^^^^ Use `double` (rspec-mocks) instead of `mock` (Mocha)
          RUBY
        end

        it do
          expect_offense(<<-RUBY)
            foo = mock(foo: :bar)
                  ^^^^^^^^^^^^^^^ Use `double` (rspec-mocks) instead of `mock` (Mocha)
          RUBY
        end

        include_examples 'autocorrect',
          'object = mock',
          'object = double'
        include_examples 'autocorrect',
          'object = mock(foo: :bar)',
          'object = double(foo: :bar)'
      end
    end
  end
end
