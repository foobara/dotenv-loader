RSpec.describe Foobara::LoadDotenv do
  it "has a version number" do
    expect(Foobara::LoadDotenv::VERSION).to_not be_nil
  end

  describe ".run!" do
    before do
      allow(Dotenv).to receive(:load!).and_return(nil)
    end

    context "when development env" do
      let(:env) { "development" }

      it "applies .env.development.local" do
        described_class.run!(env:, dir: "#{__dir__}/fixtures/test_dotenvs")

        expect(Dotenv).to have_received(:load!).with(
          ".env.development.test.local",
          ".env.development.local",
          ".env.local",
          ".env.development.test",
          ".env.development",
          ".env"
        )
      end
    end
  end
end
