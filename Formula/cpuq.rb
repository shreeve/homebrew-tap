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
      url "https://github.com/shreeve/cpuq/releases/download/v0.9.0/cpuq-v0.9.0-osx-arm64.tar.gz"
      sha256 "678b8f25608c4f7c110083968e5b400b31dde57d18f60cd43edcc763e0a6ede7"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.9.0/cpuq-v0.9.0-osx-amd64.tar.gz"
      sha256 "c47dff1f2c612405329ce1d0cbbb371700d682901390f2e996b23bdca2e12def"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.9.0/cpuq-v0.9.0-linux-arm64.tar.gz"
      sha256 "7e2896f1d644cb29b0760663a9b4badffcd694da301b0b51999b5c5595ce2c94"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.9.0/cpuq-v0.9.0-linux-amd64.tar.gz"
      sha256 "808b35555c434815cca57900603e85c5bf0d2dc10132157bd246d452765643a4"
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
