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
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.12/cpuq-v0.7.12-osx-arm64.tar.gz"
      sha256 "c6aee232cc6aea962d3bc190d1e3eea2219b165cf2e4ee0bdb97550d447966c3"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.12/cpuq-v0.7.12-osx-amd64.tar.gz"
      sha256 "a4f7f3c5985a87134950aecec86c426c01548edd3cd3232592faf9f73662eea0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.12/cpuq-v0.7.12-linux-arm64.tar.gz"
      sha256 "47ca344e9067fa530ce1fe5ac6178545c8e033998ced8d782ed02885a1f5b1fe"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.12/cpuq-v0.7.12-linux-amd64.tar.gz"
      sha256 "ec9b0de539bfbfb80f0bf09d4bf8a2a3f2fa9cb70b8e0b2b2a06a5c02023434a"
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
