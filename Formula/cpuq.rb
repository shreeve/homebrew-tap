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
      url "https://github.com/shreeve/cpuq/releases/download/v0.10.0/cpuq-v0.10.0-osx-arm64.tar.gz"
      sha256 "fa7779767cfacf8078e02051ed9d0afea9d268b7124cbf2f08a0619b89955496"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.10.0/cpuq-v0.10.0-osx-amd64.tar.gz"
      sha256 "51382d0490452870b7acefa135c6adf6f4c0d115dde8d0ef174cd3d975b0d7e1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.10.0/cpuq-v0.10.0-linux-arm64.tar.gz"
      sha256 "c239bf95f06b9748406d9835be6126b707cd8e65d4634ce3865e5421ee1765bd"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.10.0/cpuq-v0.10.0-linux-amd64.tar.gz"
      sha256 "c6d95e4e8d6a83b662c4a2168ff8d33debbe3695eb53888e432165acd162ea25"
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
