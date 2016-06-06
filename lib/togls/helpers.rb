module Togls
  # Helpers
  #
  # Collection of helper methods used through the Togls library.
  module Helpers
    def self.sha1(*args)
      Digest::SHA1.hexdigest(args.join(':'))
    end
  end
end
