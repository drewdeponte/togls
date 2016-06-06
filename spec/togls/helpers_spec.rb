require 'spec_helper'

RSpec.describe Togls::Helpers do
  describe ".sha1" do
    it "return the hex sha1 the arguments converted to strings and join by a colon" do
      sha1 = Digest::SHA1.hexdigest("boolean:true:foo")
      expect(Togls::Helpers.sha1(:boolean, true, :foo)).to eq(sha1)
    end
  end
end
