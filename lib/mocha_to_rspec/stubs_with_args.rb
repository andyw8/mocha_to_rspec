require 'rubocop/cop/internal_affairs'

module RuboCop
  module Cop
    module MochaToRSpec
      class StubsWithArgs < Cop
        # TODO Use seperate messages for allow/expect.
        MSG = "Use `allow/expect(Object).to receive(...).with(...)` (rspec-mocks) instead of `Object.stubs/expects(...).with(...)` (Mocha)".freeze
        def_node_matcher :candidate?, <<-CODE
  $(send
    $(send
      _
      ${:stubs :expects}
      _
    )
    :with
    ...
  )
CODE

        def on_send(node)
          candidate?(node) do
            add_offense(node, location: :selector)
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            receiver, _with, *args = *node # ..., :with, :bar
            args_list = args.map(&:source).join(", ")
            subject, variant, method_name = *receiver # Object, :stubs, :foo

            allow_or_expect = case variant
                              when :stubs
                                "allow"
                              when :expects
                                "expect"
                              else
                                raise
                              end

            replacement = "#{allow_or_expect}(#{subject.source}).to receive(#{method_name.source}).with(#{args_list})"
            corrector.replace(node.source_range, replacement)
          end
        end
      end
    end
  end
end
