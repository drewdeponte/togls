module Togls
  # Helpers
  #
  # Collection of helper methods used through the Togls library.
  module Helpers
    def self.sha1(klass, data)
      Digest::SHA1.hexdigest("#{klass}:#{data}")
    end
  end
end
