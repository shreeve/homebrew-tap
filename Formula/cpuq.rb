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
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.13/cpuq-v0.7.13-osx-arm64.tar.gz"
      sha256 "c850faab7cb81f86e1807d705eeca674f20d23f9d403f135c7aeb79b393d9b62"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.13/cpuq-v0.7.13-osx-amd64.tar.gz"
      sha256 "a7c817a0f3fe90cf22615b750b557cce4c41e92e1e7ea45935bffae308c83ce9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.13/cpuq-v0.7.13-linux-arm64.tar.gz"
      sha256 "dff80f6a1e606aa17909f319a6a7df5287e907d859c57db84651bfd97fa76e72"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.13/cpuq-v0.7.13-linux-amd64.tar.gz"
      sha256 "9739ba99cae4fd786c657c3e7dab55a7f4b0c9a66487ee3f097441063632f7e9"
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
