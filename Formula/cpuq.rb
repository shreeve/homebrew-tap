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
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.2/cpuq-v0.30.2-osx-arm64.tar.gz"
      sha256 "0fbaec340438ef0632dbd26dc67771633047788b3b5d179916a1833c395ed89a"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.2/cpuq-v0.30.2-osx-amd64.tar.gz"
      sha256 "28593ab6e19e68488a67ff0302e1ddee4753ce7fe8b27f4ef7bbe2a49c4521fa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.2/cpuq-v0.30.2-linux-arm64.tar.gz"
      sha256 "653c466a198f30c403de192840d565dd3e6f43d980f2ae8f665893b0fc68ceb5"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.2/cpuq-v0.30.2-linux-amd64.tar.gz"
      sha256 "75731cc3d4fe6d06b0d4af203c79f4db5882fe210e5298aabd882cca344883c4"
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
