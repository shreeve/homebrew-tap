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
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.5/cpuq-v0.25.5-osx-arm64.tar.gz"
      sha256 "51e69a4494bce37ee19f5feb45399086de2f5b85aa3e98808ca7bf9c2ac2c92f"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.5/cpuq-v0.25.5-osx-amd64.tar.gz"
      sha256 "12173569e25b0b5ca3645ec19b823b7d354a6fb9b4bb97e69196138abd60bbd9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.5/cpuq-v0.25.5-linux-arm64.tar.gz"
      sha256 "0e90e1ceb66b76cb61a0f6a313dc4487804ae7be0add76bd45b51ca187be4489"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.5/cpuq-v0.25.5-linux-amd64.tar.gz"
      sha256 "6224bbdf8f930ce2e7207cf516e2581a7d89951dfc4819c04997058e86924b9c"
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
