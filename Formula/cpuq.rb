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
      url "https://github.com/shreeve/cpuq/releases/download/v0.16.3/cpuq-v0.16.3-osx-arm64.tar.gz"
      sha256 "08183cc446535e76e7f143d06bac75e03b519153b49f5c32978bc4030caca13d"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.16.3/cpuq-v0.16.3-osx-amd64.tar.gz"
      sha256 "f70d65f44a258456d951610053198deea11a66f09c3649319fbe5ac9200a00fe"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.16.3/cpuq-v0.16.3-linux-arm64.tar.gz"
      sha256 "5dd824d85803c4fde9cfb8f98b5d5ba849afbb544c89aad6c942857f8e35c977"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.16.3/cpuq-v0.16.3-linux-amd64.tar.gz"
      sha256 "d8277704d6becac6e6e9f9be9ef58506ebd855ba9fccf6106e3062fddd23e412"
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
