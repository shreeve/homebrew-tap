class GitEnc < Formula
  desc "Encrypted secrets in git, declared in .gitignore"
  homepage "https://github.com/shreeve/git-enc"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/shreeve/git-enc/releases/download/v0.1.0/git-enc-v0.1.0-osx-arm64.tar.gz"
      sha256 "6d7db9a6221b27c0f76736512c5a8c21d1117a318bac765c666e42c9e50c4418"
    end
    on_intel do
      url "https://github.com/shreeve/git-enc/releases/download/v0.1.0/git-enc-v0.1.0-osx-amd64.tar.gz"
      sha256 "fe81ee661511eac99b9d28c2f67efcdd4f391a47eaeb3b1e97c34308a0487129"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/git-enc/releases/download/v0.1.0/git-enc-v0.1.0-linux-arm64.tar.gz"
      sha256 "ffb1fa46fc098821caf05ed70fd782b28fe252cd41cfd37e4eeeba96766e0bdf"
    end
    on_intel do
      url "https://github.com/shreeve/git-enc/releases/download/v0.1.0/git-enc-v0.1.0-linux-amd64.tar.gz"
      sha256 "d8105e0ee4c4000c48520f4f6c32742929efe6a9a10c3b39b6214797549c413e"
    end
  end

  def install
    bin.install "git-enc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-enc version")
    system "git", "init", "--quiet"
    assert_match "no git-enc secrets", shell_output("#{bin}/git-enc status")
  end
end
