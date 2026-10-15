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
      url "https://github.com/shreeve/cpuq/releases/download/v0.12.0/cpuq-v0.12.0-osx-arm64.tar.gz"
      sha256 "df0e91b6ed57b7c42a530190fe6162874247fe8ae7d311d2f17b3558c7c1724b"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.12.0/cpuq-v0.12.0-osx-amd64.tar.gz"
      sha256 "7d4e5c46a6be894ef7be6a5aecb93ebdeed635f29747ec25047f839c50dabaa9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.12.0/cpuq-v0.12.0-linux-arm64.tar.gz"
      sha256 "510d82c104d2fdd7d950e0c1c08133a8b25ead8881acfcdd06ee4de2813a13cd"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.12.0/cpuq-v0.12.0-linux-amd64.tar.gz"
      sha256 "95154b5f3444595891d1d31a54e0f19d2b4a6d7b9c1d0faf79cc0939ca79fdd7"
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
