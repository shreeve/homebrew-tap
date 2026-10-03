class DuckdbHarbor < Formula
  desc "DuckDB served over plain HTTP to many clients, with a REPL of its own"
  homepage "https://github.com/shreeve/duckdb-harbor"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/shreeve/duckdb-harbor/releases/download/v0.43.4/harbor-v0.43.4-osx-arm64.tar.gz"
      sha256 "d6c6aec80dac44e94254ea74f1b36f1f9ea8610e9a664a180f491915b4d0c433"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/duckdb-harbor/releases/download/v0.43.4/harbor-v0.43.4-linux-arm64.tar.gz"
      sha256 "b220e05c474c98c68aa7e077ec6cd745a9d8c73fd1912a9adbcf65e358114709"
    end
    on_intel do
      url "https://github.com/shreeve/duckdb-harbor/releases/download/v0.43.4/harbor-v0.43.4-linux-amd64.tar.gz"
      sha256 "6d0aa470046ae817c32ef4da63d3b7f1cec1f947d62d29e680864e3a584b7427"
    end
  end

  def install
    # harbor loads libduckdb at runtime, from ../lib beside its own
    # executable first. The pair goes under libexec so the library never
    # lands in #{HOMEBREW_PREFIX}/lib, where the duckdb formula puts its own.
    libexec.install "bin", "lib"

    # The launcher goes through opt, not the keg. harbor records the path it
    # was started from when it installs a login item, and opt is the path
    # that survives an upgrade.
    (bin/"harbor").write <<~SH
      #!/bin/bash
      exec "#{opt_libexec}/bin/harbor" "$@"
    SH
  end

  def caveats
    <<~EOS
      Upgrade with `brew upgrade duckdb-harbor`. `harbor update` is for a copy
      installed by install.sh and would write over this one.

      A running server keeps the code it started with: after an upgrade,
      `harbor` lists each server's version, and `harbor <db> restart` brings
      one forward.
    EOS
  end

  test do
    assert_match "harbor #{version}", shell_output("#{bin}/harbor --version")
    ENV["HARBOR_HOME"] = testpath/"h"
    db = testpath/"x.duckdb"
    assert_match "42", shell_output("#{bin}/harbor #{db} --mode csv -c 'SELECT 42 AS answer'")
    system bin/"harbor", db, "stop"
  end
end
