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
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.0/cpuq-v0.7.0-osx-arm64.tar.gz"
      sha256 "e4e2df5300ea8de0473705ae4e09b540e3e9b081cadd8dd224a4e71b5b4f057c"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.0/cpuq-v0.7.0-osx-amd64.tar.gz"
      sha256 "2918804446ecbd3651ae323b9a3c6ee51a6b0ca6f02b334001a448db222cfa5e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.0/cpuq-v0.7.0-linux-arm64.tar.gz"
      sha256 "b1426746fd57f72dce99034ab487c89115f21ae5fc681f9f8a8e36a288a7b5e0"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.0/cpuq-v0.7.0-linux-amd64.tar.gz"
      sha256 "e4cfb833be1f249683ef59a1e4d56df12f59fd3c12ed952b09d1339140369377"
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
