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
      url "https://github.com/shreeve/cpuq/releases/download/v0.28.0/cpuq-v0.28.0-osx-arm64.tar.gz"
      sha256 "87af3278f9e5a9760358517a4c8f02c78c45c4ab6852ff509932341b6e80a76b"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.28.0/cpuq-v0.28.0-osx-amd64.tar.gz"
      sha256 "4b750da2ec273b47bc1fd47db0ff40ec8ae709368125073a79cf035495225b67"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.28.0/cpuq-v0.28.0-linux-arm64.tar.gz"
      sha256 "855b6c3191f450319c9e00df93d63cbfd830658e7b9fddad349a5cdd955a9d60"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.28.0/cpuq-v0.28.0-linux-amd64.tar.gz"
      sha256 "41c8dcb3b2019dd29ae66172567c1fe18e1de1a77c597f138c190014a212d342"
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
