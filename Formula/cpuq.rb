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
      url "https://github.com/shreeve/cpuq/releases/download/v0.11.1/cpuq-v0.11.1-osx-arm64.tar.gz"
      sha256 "d70d357ca617e5efa1a7ee3c0ba2ef616bc7425c603080927c47f6d519855d88"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.11.1/cpuq-v0.11.1-osx-amd64.tar.gz"
      sha256 "bcb54cf965ab554e6e74fbac1cbde64aeeb21443d490a4b310ac807552b0c7d8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.11.1/cpuq-v0.11.1-linux-arm64.tar.gz"
      sha256 "d9638ab0f79b2ca6a73db0f31ad54164db1170a2267385576caae211cc78ba96"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.11.1/cpuq-v0.11.1-linux-amd64.tar.gz"
      sha256 "a4f50b962cad3f9d7d545c2c5b4686f44b9bea827055e63dbc972966aaec5047"
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
