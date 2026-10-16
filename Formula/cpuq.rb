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
      url "https://github.com/shreeve/cpuq/releases/download/v0.24.3/cpuq-v0.24.3-osx-arm64.tar.gz"
      sha256 "23a6731643d71cab37272bd87ac1a1215fd39f9cb3b61fb02ce42a24fc590c61"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.24.3/cpuq-v0.24.3-osx-amd64.tar.gz"
      sha256 "6e44c9048b5f2c75f3c21817770c108414bdcd339256b3b1f5749359971b86b5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.24.3/cpuq-v0.24.3-linux-arm64.tar.gz"
      sha256 "37ca629dc212af6a0177eef3d77a3f7ba5d4ddea5b9959328d776d2870c9dbf1"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.24.3/cpuq-v0.24.3-linux-amd64.tar.gz"
      sha256 "99bfc52078a8337c585c21142abcdf3f8c2a600ac9867724c7e8282a2ae28a9b"
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
