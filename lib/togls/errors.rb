module Togls
  class Error < StandardError; end
  class NoFeaturesError < Error; end
  class MissingDriver < Error; end
  class InvalidDriver < Error; end
  class NotImplemented < Error; end
end
