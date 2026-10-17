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
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.5/cpuq-v0.26.5-osx-arm64.tar.gz"
      sha256 "d45167acd100321af457b45b74e9d854e38816ca9fbe049989aaf80adb5de6e0"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.5/cpuq-v0.26.5-osx-amd64.tar.gz"
      sha256 "926d08977868a65aac4464bb8b63c4470684c3049853f1faa8d8eac587d29cba"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.5/cpuq-v0.26.5-linux-arm64.tar.gz"
      sha256 "9628e64d645e3243a4f62ff78424a0509bae4f903f8f5af7ece9986f6f679778"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.5/cpuq-v0.26.5-linux-amd64.tar.gz"
      sha256 "32b145bd6c99f8e60de20c93b3ee2351ce805a3391be26bea885ef1ec8d7165c"
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
