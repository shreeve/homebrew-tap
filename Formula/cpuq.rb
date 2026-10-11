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
      url "https://github.com/shreeve/cpuq/releases/download/v0.11.0/cpuq-v0.11.0-osx-arm64.tar.gz"
      sha256 "204e3effa8873dcdd3e4c26793ae226d72d1de407162a24196603b7858103381"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.11.0/cpuq-v0.11.0-osx-amd64.tar.gz"
      sha256 "dddf4a43e3d9bdd4b9d34eab39c9c6d1708032286e8f5162fc9e422cee631e3d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.11.0/cpuq-v0.11.0-linux-arm64.tar.gz"
      sha256 "60becbe83e9dba5732ce8034024a2e40bcbc6d3f2627c64d8287a356c7614265"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.11.0/cpuq-v0.11.0-linux-amd64.tar.gz"
      sha256 "9b3dce1bf3a0d0ae11348f5d2fa0bd0c5d006b9e97cde614c151fb1b5fbc2568"
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
