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
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.0/cpuq-v0.26.0-osx-arm64.tar.gz"
      sha256 "3f8730fb65aa4184b4b0fbf6f5336179d6b37d1f57010ebe37eb288ac7b13fe8"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.0/cpuq-v0.26.0-osx-amd64.tar.gz"
      sha256 "e99406254bc9ed0c87c70bc80473e607b6c386c6e63e8bcec55d395b47e2273b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.0/cpuq-v0.26.0-linux-arm64.tar.gz"
      sha256 "7734cf4e94d652bb98f83fd7d0048aae2bbf01862d613c2e4ce291fb4aa669a7"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.0/cpuq-v0.26.0-linux-amd64.tar.gz"
      sha256 "e68c0009e4e88e1fee0d09ed656e489137dfbbf76072559150ba0cb467cf899c"
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
