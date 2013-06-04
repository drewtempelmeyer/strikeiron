module Strikeiron #:nodoc:
  # Configuration values for Strikeiron such as your UserID and Password.
  #
  # === Attributes
  # * <tt>user_id</tt> - The UserID supplied by Strikeiron for API use.
  # * <tt>password</tt> - The password/key that Strikeiron supplied for API use.
  class Configuration
    attr_accessor :user_id, :password
    attr_writer :logging

    def logging
      @logging ||= false
    end
  end
end
