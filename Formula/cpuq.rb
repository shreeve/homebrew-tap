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
      url "https://github.com/shreeve/cpuq/releases/download/v0.2.0/cpuq-v0.2.0-osx-arm64.tar.gz"
      sha256 "d23ef878ed99f3040ba0e3c254c971ca819a5f0a94f35c01f253f39f2021fce6"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.2.0/cpuq-v0.2.0-osx-amd64.tar.gz"
      sha256 "f8577339ae10b1aade07109be213e87a97e960f5b20a7dd96c73278e8a76bbaa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.2.0/cpuq-v0.2.0-linux-arm64.tar.gz"
      sha256 "a05637a551c8667b4ae0858a35626ca176b80107d75be978b2ae53eab3503891"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.2.0/cpuq-v0.2.0-linux-amd64.tar.gz"
      sha256 "aba0e111c6399c49c0f724eae6512fbb86f222d395df71ea97656f584205e2f2"
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
