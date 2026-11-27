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
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.4/cpuq-v0.30.4-osx-arm64.tar.gz"
      sha256 "ec9e04a6ac63d594dbacdebd9ceca674e8fbc75e31f76844a2e7b197378a08c3"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.4/cpuq-v0.30.4-osx-amd64.tar.gz"
      sha256 "316ce6201206d881d6d33199e231ea1bcdee3950fff5f1ea03261c46c17d99f2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.4/cpuq-v0.30.4-linux-arm64.tar.gz"
      sha256 "a78bccc7d56a171af0d4adb04b7b6c9e27537f7e4d4dad90d64623c6844f08a3"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.4/cpuq-v0.30.4-linux-amd64.tar.gz"
      sha256 "2d6d60b6b3e457a6ea851a6ef537e57c8c92342f81b5f022cfb7976a9bff8342"
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
