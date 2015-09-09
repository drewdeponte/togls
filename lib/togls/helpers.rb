module Togls
  module Helpers
    def self.sha1(klass, data)
      Digest::SHA1.hexdigest("#{klass}:#{data.to_s}")
    end
  end
end
