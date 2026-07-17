class Magritte < Formula
  desc "Standalone macOS git client in the spirit of Magit"
  homepage "https://github.com/lyallcooper/magritte"
  version "0.8.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lyallcooper/magritte/releases/download/v0.8.1/magritte-v0.8.1-aarch64-apple-darwin.tar.gz"
      sha256 "41346d4caca7edcf7fa81c1c88dc6154dddb278adaa885c73e52667c0e2ff4f2"
    else
      odie "Magritte currently ships a macOS Apple Silicon artifact only"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/lyallcooper/magritte/releases/download/v0.8.1/magritte-v0.8.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "16b5f8d1647bb945b2be6f3d5e1f3807f2fe97abd3532076eef01640f8904d77"
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
