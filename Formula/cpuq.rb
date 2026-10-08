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
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.10/cpuq-v0.8.10-osx-arm64.tar.gz"
      sha256 "e27b20b47d3e26a309e5d99ccbbab3ad87309f8e47e84e709b5f78b7068d59c7"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.10/cpuq-v0.8.10-osx-amd64.tar.gz"
      sha256 "55bbe043c359feddc915fc0b984b28830f4e77c20273a8a7251fdd6ddba27672"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.10/cpuq-v0.8.10-linux-arm64.tar.gz"
      sha256 "d04d2f7afe2be079842792b822a31ed659aa4aa43aad6f606b2bfd9f1debb66d"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.10/cpuq-v0.8.10-linux-amd64.tar.gz"
      sha256 "5d7d61875c9898a395fa931d5c4657c1dd02da87133b0635e6ec4dbb2e696182"
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
