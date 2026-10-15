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
      url "https://github.com/shreeve/cpuq/releases/download/v0.12.1/cpuq-v0.12.1-osx-arm64.tar.gz"
      sha256 "f30f5326eaa97f943324fdaaf6676e273717da064466b91082dbced25c4cf9b5"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.12.1/cpuq-v0.12.1-osx-amd64.tar.gz"
      sha256 "262301e4a52a162817ed4c3f739253bf3c98efd227cd88f99f20cdf2ad70d915"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.12.1/cpuq-v0.12.1-linux-arm64.tar.gz"
      sha256 "154238faf5608168a0355c5fcba91190616be833ec80743ade556431e5adc123"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.12.1/cpuq-v0.12.1-linux-amd64.tar.gz"
      sha256 "eb0b3fe216a5d7a2963519731da3f066b9a339083c0ebf6877a03c392bc77ca5"
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
