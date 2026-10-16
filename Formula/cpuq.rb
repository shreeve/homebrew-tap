class Cpuq < Formula
  desc "Machine-wide jobserver for builds, tests, benchmarks and coding agents"
  homepage "https://github.com/shreeve/cpuq"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.1/cpuq-v0.25.1-osx-arm64.tar.gz"
      sha256 "1aa9458cf90c6570e4b816c90cdfac4ca0642858ed30b5a10bf429cafedf885e"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.1/cpuq-v0.25.1-osx-amd64.tar.gz"
      sha256 "b7d21c60a02eb4823612ef52f3a1a50069490cd0a7b49afca36c882b75a79da5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.1/cpuq-v0.25.1-linux-arm64.tar.gz"
      sha256 "397910fe350f47c5b494b7c77618c63e6cd62e80edc052cf3cbe2a4f9760fd8e"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.1/cpuq-v0.25.1-linux-amd64.tar.gz"
      sha256 "a068a053d8bc16c64d0776c74c0cd541df0b8c5cad08d29d8a5366b7f216c057"
    end
  end

  def install
    bin.install "cpuq"
    doc.install "README.md", "CHANGELOG.md"
  end

  test do
    assert_match "cpuq #{version}", shell_output("#{bin}/cpuq --version")
    # A private queue with the machine gates off, so the test depends on
    # neither the load nor the size of the machine it runs on.
    (testpath/"config").write "load_check = off\npressure_check = off\nactive_cap = off\n"
    ENV["CPUQ_DIR"] = (testpath/"state").to_s
    ENV["CPUQ_CONFIG"] = (testpath/"config").to_s
    ENV["CPUQ_BUDGET"] = "2"
    ran = shell_output("#{bin}/cpuq run --cores 2 -- sh -c 'echo ran with $CPUQ_CORES cores'")
    assert_equal "ran with 2 cores", ran.strip
    assert_match "\"held\": 0", shell_output("#{bin}/cpuq status --json")
  end
end
