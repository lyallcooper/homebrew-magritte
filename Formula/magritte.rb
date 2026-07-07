class Magritte < Formula
  desc "Standalone macOS git client in the spirit of Magit"
  homepage "https://github.com/lyallcooper/magritte"
  version "0.5.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lyallcooper/homebrew-magritte/releases/download/v0.5.0/magritte-v0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "9708e356c64c4150621b66084bfa45880ccbc242b50e690dc0250bd9860a293f"
    else
      odie "Magritte currently ships a macOS Apple Silicon artifact only"
    end
  end

  on_linux do
    odie "Magritte does not yet ship a Linux artifact for this release"
  end

  def install
    if OS.mac?
      app = Pathname.glob("*.app").first
      if app
        prefix.install app
      elsif (buildpath/"Contents").directory?
        (prefix/"Magritte.app").install "Contents"
      else
        prefix.install buildpath => "Magritte.app"
      end
      (bin/"magritte").write <<~SH
        #!/bin/sh
        exec "#{opt_prefix}/Magritte.app/Contents/MacOS/magritte" "$@"
      SH
    else
      bin.install "bin/magritte"
      share.install "share"
    end
  end

  test do
    system "#{bin}/magritte", "--help"
  end
end
