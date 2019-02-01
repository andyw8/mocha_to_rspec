require "rubocop/cop/mocha_to_rspec/raises"

module RuboCop
  module Cop
    module MochaToRSpec
      describe Context do
        include RuboCop::RSpec::ExpectOffense

        DEFAULT_FILENAME = 'example.rb'.freeze

        subject(:cop) { described_class.new }

        specify do
          expect_no_offenses(<<-RUBY)
            obj.stubs(:foo)
          RUBY
        end

        specify do
          expect_offense(<<-RUBY)
            before(:all) do
              obj.stubs(:foo)
                  ^^^^^ Stubbing not allowed here
            end
          RUBY
        end

        specify do
          expect_offense(<<-RUBY)
            before(:all) do
              obj.expects(:foo)
                  ^^^^^^^ Stubbing not allowed here
            end
          RUBY
        end

        specify do
          expect_offense(<<-RUBY)
            before(:all) do
              obj.any_instance.stubs(:foo)
                               ^^^^^ Stubbing not allowed here
            end
          RUBY
        end

        specify do
          expect_offense(<<-RUBY)
            before(:all) do
              obj.any_instance.expects(:foo)
                               ^^^^^^^ Stubbing not allowed here
            end
          RUBY
        end
      end
    end
  end
end
