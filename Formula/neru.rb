class Neru < Formula
  desc "Keyboard driven navigation for linux"
  homepage "https://github.com/y3owk1n/neru"
  version "1.53.0"
  license "MIT"

  on_macos do
    odie "neru (Linux formula) does not support macOS — use the neru cask instead"
  end

  if Hardware::CPU.arm?
    url "https://github.com/y3owk1n/neru/releases/download/v#{version}/neru-linux-arm64.zip"
    sha256 "3bc2f9c36188bcf6354eab1bc0dbd993d2ea4b5b8525ad9ee380021d31f8e02a"
  else
    url "https://github.com/y3owk1n/neru/releases/download/v#{version}/neru-linux-amd64.zip"
    sha256 "84f28fd238a0f30efb40a10f0c9aa630d36a52ee551f02f26bf236984aafea5b"
  end

  depends_on "patchelf" => :build
  depends_on "tesseract"
  depends_on "libei"

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    bin.install "bin/neru"
    man1.install Dir["share/man/man1/*.1"]

    # The upstream binary has no RPATH/RUNPATH at all — it was built assuming
    # libtesseract/libei/liboeffis live in a system path like /usr/lib.
    # Homebrew on Linux never touches system library paths, so without this
    # the dynamic linker can't find them even though they're installed.
    system "patchelf", "--set-rpath",
                        "#{Formula["tesseract"].opt_lib}:#{Formula["libei"].opt_lib}",
                        bin/"neru"

    generate_completions_from_executable(bin/"neru", "completion", shells: [:bash, :zsh, :fish])
  end

  def caveats
    <<~EOS
      Config is read from ~/.config/neru
      Logs (if any) may be found in /tmp/neru.log and /tmp/neru.err.log
    EOS
  end

  test do
    system "#{bin}/neru", "--version"
  end
end
