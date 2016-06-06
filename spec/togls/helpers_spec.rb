require 'spec_helper'

RSpec.describe Togls::Helpers do
  describe ".sha1" do
    it "return the hex sha1 of the rule klass with the initalizer data" do
      sha1 = Digest::SHA1.hexdigest("Togls::Rules::Boolean:true")
      expect(Togls::Helpers.sha1(Togls::Rules::Boolean, true)).to eq(sha1)
    end
  end
end
