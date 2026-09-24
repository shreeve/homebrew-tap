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
      url "https://github.com/shreeve/git-enc/releases/download/v0.1.1/git-enc-v0.1.1-osx-arm64.tar.gz"
      sha256 "9fb8fa48986ad096726fe71cf29d041957874028b66d3f312350fab9319b6cc7"
    end
    on_intel do
      url "https://github.com/shreeve/git-enc/releases/download/v0.1.1/git-enc-v0.1.1-osx-amd64.tar.gz"
      sha256 "73e0eb168d8e8e4f7f88363587cd07b784a4f2c89252f31c51101aa76911c634"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/git-enc/releases/download/v0.1.1/git-enc-v0.1.1-linux-arm64.tar.gz"
      sha256 "0a9836a1ea845123235118c7e9969e074c9f1a8569e7fc467fdf9f795532497c"
    end
    on_intel do
      url "https://github.com/shreeve/git-enc/releases/download/v0.1.1/git-enc-v0.1.1-linux-amd64.tar.gz"
      sha256 "1f76c3a95c67ec50b6652af26da006e13d5382b2a388d30c71b8c41181e2df0c"
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
