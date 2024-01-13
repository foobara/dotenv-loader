RSpec.describe Foobara::LoadDotenv do
  let(:dir) { "#{__dir__}/fixtures/test_dotenvs" }

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
        described_class.run!(env:, dir:)

        expect(Dotenv).to have_received(:load!).with(
          ".env.development.test.local",
          ".env.development.local",
          ".env.local",
          ".env.development.test",
          ".env.development",
          ".env"
        )
      end

      context "when no .env files" do
        let(:dir) { "#{__dir__}/fixtures/no_dotenvs" }

        it "does nothing" do
          expect {
            described_class.run!(env:, dir:)
          }.to_not raise_error
        end
      end

      context "when no root .env file but there are others" do
        let(:dir) { "#{__dir__}/fixtures/no_root_dotenv" }

        it "does not try to load .env" do
          described_class.run!(env:, dir:)

          expect(Dotenv).to have_received(:load!).with(".env.development.test")
        end
      end
    end
  end
end
