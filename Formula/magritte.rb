class Magritte < Formula
  desc "Standalone macOS git client in the spirit of Magit"
  homepage "https://github.com/lyallcooper/magritte"
  version "0.8.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lyallcooper/magritte/releases/download/v0.8.0/magritte-v0.8.0-aarch64-apple-darwin.tar.gz"
      sha256 "866698cc7534d1c8bf91ba3e3e8149562d9a7bb3216ea1bb3dc559fe460392d8"
    else
      odie "Magritte currently ships a macOS Apple Silicon artifact only"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/lyallcooper/magritte/releases/download/v0.8.0/magritte-v0.8.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "19895f230cf4f5fb4cd1efbd8a5aa0fd649decba257bd95463b2414bc23f356f"
    else
      odie "Magritte currently ships a Linux x86_64 artifact only"
    end
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
