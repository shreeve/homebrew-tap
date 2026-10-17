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
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.1/cpuq-v0.26.1-osx-arm64.tar.gz"
      sha256 "f6795d8f508a610f5fba0424607d222feab7b136e7bba8bfe36a2f2112df8ae2"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.1/cpuq-v0.26.1-osx-amd64.tar.gz"
      sha256 "ca38297bac7d9c5db779d52ba0def6af6612d603dd77c38cdd1bb21502d9d115"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.1/cpuq-v0.26.1-linux-arm64.tar.gz"
      sha256 "8522289a9738a7f9b1c8d1e9bc8362ca99f31e8095d9273a57ea7ddd2c5f62d3"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.1/cpuq-v0.26.1-linux-amd64.tar.gz"
      sha256 "924bb1aad9f920347e1fa8eed1b64bac8e5f0e3e5f09439dd4726f3ebde13ca8"
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
