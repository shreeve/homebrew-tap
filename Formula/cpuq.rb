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
      url "https://github.com/shreeve/cpuq/releases/download/v0.14.0/cpuq-v0.14.0-osx-arm64.tar.gz"
      sha256 "87d5f18d8479d31d216296340adbfbb44b68368f35a849e4d19eef57666ad6b2"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.14.0/cpuq-v0.14.0-osx-amd64.tar.gz"
      sha256 "a28cc601a065ac36fb7279201245deaebf1e9b0939dbaa28c2cfeade232f12ae"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.14.0/cpuq-v0.14.0-linux-arm64.tar.gz"
      sha256 "3074f5353c268fb8c963c750b5cee566d75d99c74fe07f3dbf554ada9b3cfe64"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.14.0/cpuq-v0.14.0-linux-amd64.tar.gz"
      sha256 "38303b333265c9e6d776f58045948a35c29b10707cad22dc7b0212e9f7d1fba2"
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
