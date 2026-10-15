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
      url "https://github.com/shreeve/cpuq/releases/download/v0.20.0/cpuq-v0.20.0-osx-arm64.tar.gz"
      sha256 "0bdd003fe159d72b851d2abb6d0015e1e6dff090173dfb7737dc66da9508fde1"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.20.0/cpuq-v0.20.0-osx-amd64.tar.gz"
      sha256 "e7ab618f1f702ea1723f7359b66e107b94e813d9744abe9dbaa6ce3f68cffc18"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.20.0/cpuq-v0.20.0-linux-arm64.tar.gz"
      sha256 "b7e990ae98b0b71a4bc805a81668a1b3631778e6a3d16284dd509b2780df966e"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.20.0/cpuq-v0.20.0-linux-amd64.tar.gz"
      sha256 "d12697d3e9240409d0a3957ec82ddfca863ffeb716fea591d9113896456c7ed6"
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
