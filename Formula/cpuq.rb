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
      url "https://github.com/shreeve/cpuq/releases/download/v0.29.0/cpuq-v0.29.0-osx-arm64.tar.gz"
      sha256 "4e8a8f9d082623f50dc737272158c251cf5b55976b6d1df39fdeb137336b73e8"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.29.0/cpuq-v0.29.0-osx-amd64.tar.gz"
      sha256 "8943b2e3e46ece4e8a0c9c0cb017a5d1eac8a7ea34ef7be0a286960e7be24876"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.29.0/cpuq-v0.29.0-linux-arm64.tar.gz"
      sha256 "8ffde2df907337299a2681a65a008fd892f20a9850f3c6e39b9f36cf403e6722"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.29.0/cpuq-v0.29.0-linux-amd64.tar.gz"
      sha256 "80cc5cbf8629c60d20940a2ae18276487346658ecc0df20cfa898afb47e58ee2"
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
