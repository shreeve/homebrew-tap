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
      url "https://github.com/shreeve/cpuq/releases/download/v0.34.0/cpuq-v0.34.0-osx-arm64.tar.gz"
      sha256 "814e7b415716810e7c3b4c9c7f7706f7773edad4af684a7602b3098cbb962e8d"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.34.0/cpuq-v0.34.0-osx-amd64.tar.gz"
      sha256 "b8fecd28409ae555eb90449d0a9dc2deefa08d52a88827453ce1682c8dab87fe"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.34.0/cpuq-v0.34.0-linux-arm64.tar.gz"
      sha256 "b03716cc099bcc8be7cad7796d3c1bcec08946e52580cb8709b4f4dd24eb9412"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.34.0/cpuq-v0.34.0-linux-amd64.tar.gz"
      sha256 "71b063e69ace365231eb169827db1109f4b25d3fc34bd68fba66b3d64e7a2a36"
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
