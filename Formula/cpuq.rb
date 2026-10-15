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
      url "https://github.com/shreeve/cpuq/releases/download/v0.17.2/cpuq-v0.17.2-osx-arm64.tar.gz"
      sha256 "60e26745226105e1f78bd0dae2256224ce2e5f33593af849bf6172a30f40b6dc"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.17.2/cpuq-v0.17.2-osx-amd64.tar.gz"
      sha256 "a9a2c68d4acdc0a95dfe7bd9d27352be49a300c47e90f0d653c345e276b44c91"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.17.2/cpuq-v0.17.2-linux-arm64.tar.gz"
      sha256 "0eb8b9bcc0f5886eb144af436ceb46b920185976d6531c9e09c7e250146a67e5"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.17.2/cpuq-v0.17.2-linux-amd64.tar.gz"
      sha256 "4ac7bdaa28f43faf07e201ea21e331d06f2cb0956345dc8676a3ecb70478b527"
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
