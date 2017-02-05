require "../spec_helper"

describe GPG::Data do
  describe ".new" do
    context "without arguments" do
      it "runs without error" do
        described_class.new
      end
    end

    context "with slice as argument" do
      it "runs without error" do
        described_class.new("foobar".to_slice)
      end
    end

    context "with string as argument" do
      it "runs without error" do
        described_class.new("foobar")
      end
    end
  end

  describe "#gets_to_end" do
    it "returns the previously written string" do
      data = described_class.new("foobar")
      data.rewind
      expect(data.gets_to_end).to eq("foobar")
    end
  end

  describe "#<<" do
    it "appends data" do
      data = described_class.new("foobar")
      data << "foo"
      data.rewind
      expect(data.gets_to_end).to eq("foobarfoo")
    end
  end
end
