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
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.10/cpuq-v0.7.10-osx-arm64.tar.gz"
      sha256 "242e914fb923bf8b2839a9b517e9bb9e50aacc8e9e4ab09610b9c18506dc9b93"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.10/cpuq-v0.7.10-osx-amd64.tar.gz"
      sha256 "14c7047bcfadac23a7bb462a38a5d7c2193669674feee611b4183298af8e214c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.10/cpuq-v0.7.10-linux-arm64.tar.gz"
      sha256 "facee535916d13fc61694245fe78762657b62a7d1ae9bf326cac7a8c3ef0655e"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.10/cpuq-v0.7.10-linux-amd64.tar.gz"
      sha256 "d479aac051dac4049baa5eddbf688671c0dd52f59fe47f13856823ba6ceb111a"
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
