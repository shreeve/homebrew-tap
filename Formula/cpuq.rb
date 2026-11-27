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
      url "https://github.com/shreeve/cpuq/releases/download/v0.31.0/cpuq-v0.31.0-osx-arm64.tar.gz"
      sha256 "b1eac5ad5fe27abe4edc9db113604f995e0bcb150cff74238685fefda0add6d9"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.31.0/cpuq-v0.31.0-osx-amd64.tar.gz"
      sha256 "f6b7d9cdbfedb78dfbe0807149766cb3fd246ccd637c58bdab13e2b1ec063d85"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.31.0/cpuq-v0.31.0-linux-arm64.tar.gz"
      sha256 "2eb7aeab5b5156541dd4d3861232044650a964d08eaaf0d94c8da8e1a81ad3ee"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.31.0/cpuq-v0.31.0-linux-amd64.tar.gz"
      sha256 "53251a4ff3d7e1cf71dec0cfe07d20767976b22640714ac5716dbb6612072012"
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
