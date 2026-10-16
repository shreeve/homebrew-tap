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
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.3/cpuq-v0.25.3-osx-arm64.tar.gz"
      sha256 "a6876e948eb54f880f1c84438ca71057d974764b4f896f99b191df7f3b091919"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.3/cpuq-v0.25.3-osx-amd64.tar.gz"
      sha256 "79e71c07251aae7d0ad113c82393da70f8a563a6751be5e902e3a6f03c6e33bd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.3/cpuq-v0.25.3-linux-arm64.tar.gz"
      sha256 "94aa6709a397aa7e3c1dc32b801abb5deee003b515e5c792969277762be7fc22"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.3/cpuq-v0.25.3-linux-amd64.tar.gz"
      sha256 "e734d8a650c0f70e07af81ccd522835b2ef04f06d14809e40aeb79a57d4feb3d"
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
