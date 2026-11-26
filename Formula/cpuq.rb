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
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.1/cpuq-v0.30.1-osx-arm64.tar.gz"
      sha256 "b44607dfcc02cb55d910d41319a87f7fde0e9a985abc1529bd05c2854b94e26e"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.1/cpuq-v0.30.1-osx-amd64.tar.gz"
      sha256 "9883f1746a2d8f89152b8686253beac80b1d055786101c6b9edd0a3954b8cb25"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.1/cpuq-v0.30.1-linux-arm64.tar.gz"
      sha256 "60b0b00d037ccc59bb5c03216979be8f9f8d06e931e30ce0a517fd35a0dc5a2a"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.1/cpuq-v0.30.1-linux-amd64.tar.gz"
      sha256 "4982bd6d2cad52fd6185a190e22949c2876388a31735ad7edcc7968762e482cd"
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
