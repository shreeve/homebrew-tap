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
      url "https://github.com/shreeve/cpuq/releases/download/v0.22.0/cpuq-v0.22.0-osx-arm64.tar.gz"
      sha256 "a6d24e6ef606c93df571d351b175e604727e24a464661782c4be9166e200c82f"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.22.0/cpuq-v0.22.0-osx-amd64.tar.gz"
      sha256 "52616c6cc47fe785cb1ba1021609f409d8455cd020fca96045beff9344de1c0e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.22.0/cpuq-v0.22.0-linux-arm64.tar.gz"
      sha256 "353496c1e337154d7fcf6208d7f4a3c72cc6a090c74dfec8f659387113794304"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.22.0/cpuq-v0.22.0-linux-amd64.tar.gz"
      sha256 "9bbd854ab146083140a2178a625e4811fc3c3f6351f6048597eb3cf270f51a95"
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
