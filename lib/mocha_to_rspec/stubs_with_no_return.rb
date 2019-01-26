require 'rubocop/cop/internal_affairs'

module RuboCop
  module Cop
    module MochaToRSpec
      class StubsWithNoReturn < Cop
        MSG = "Use `allow(...).to receive(...)` (rspec-mocks) instead of `stubs` (Mocha)".freeze

        def_node_matcher :candidate?, <<-NODE_PATTERN
          $(send $(...) :stubs sym_type?)
        NODE_PATTERN

        def on_send(node)
          candidate?(node) do |_match, stubs_receiver|
            _receiver, method_name, _args = *stubs_receiver
            return if method_name == :any_instance

            add_offense(node)
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            receiver, method, args = *node
            message, _, _ = *args
            object = receiver.source
            corrector.replace(node.source_range, "allow(#{object}).to receive(:#{message})")
          end
        end
      end
    end
  end
end
