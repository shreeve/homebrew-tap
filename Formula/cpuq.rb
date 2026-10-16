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
      url "https://github.com/shreeve/cpuq/releases/download/v0.24.0/cpuq-v0.24.0-osx-arm64.tar.gz"
      sha256 "56256b063100a9962ef792914352e667cd9e303765b53bd21043782bfe36ff2f"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.24.0/cpuq-v0.24.0-osx-amd64.tar.gz"
      sha256 "8d479900db5bed43260e83df864b494f0f320c56e13874c288b6acb03878c23d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.24.0/cpuq-v0.24.0-linux-arm64.tar.gz"
      sha256 "ce8b5903ec57b5407a9e505bd051e26914f46b2fc20afd48f8f57f01ef69d9df"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.24.0/cpuq-v0.24.0-linux-amd64.tar.gz"
      sha256 "b6e6b8dc9f74b08be75e8dac81ca1eab88758adf0fd894884b4d23c9f82bc7d0"
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
