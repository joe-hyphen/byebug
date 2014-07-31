module QuitTest
  class QuitTestCase < TestDsl::TestCase
    def setup
      @example = -> do
        byebug
        Object.new
      end

      super
    end

    def test_finishes_byebug_if_user_confirms
      Byebug::QuitCommand.any_instance.expects(:exit!)
      enter 'quit', 'y'
      debug_proc(@example)
      check_output_includes 'Really quit? (y/n)', interface.confirm_queue
    end

    def test_does_not_quit_if_user_did_not_confirm
      Byebug::QuitCommand.any_instance.expects(:exit!).never
      enter 'quit', 'n'
      debug_proc(@example)
      check_output_includes 'Really quit? (y/n)', interface.confirm_queue
    end

    def test_quits_inmediately_if_used_with_bang
      Byebug::QuitCommand.any_instance.expects(:exit!)
      enter 'quit!'
      debug_proc(@example)
      check_output_doesnt_include 'Really quit? (y/n)', interface.confirm_queue
    end

    def test_quits_inmediately_if_used_with_unconditionally
      Byebug::QuitCommand.any_instance.expects(:exit!)
      enter 'quit unconditionally'
      debug_proc(@example)
      check_output_doesnt_include 'Really quit? (y/n)', interface.confirm_queue
    end

    def test_closes_interface_before_quitting
      Byebug::QuitCommand.any_instance.stubs(:exit!)
      interface.expects(:close)
      enter 'quit!'
      debug_proc(@example)
    end

    def test_quits_if_used_with_exit_alias
      Byebug::QuitCommand.any_instance.expects(:exit!)
      enter 'exit!'
      debug_proc(@example)
    end
  end
end
