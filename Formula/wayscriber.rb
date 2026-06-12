class Wayscriber < Formula
  desc "Screen annotation tool for Wayland compositors"
  homepage "https://wayscriber.com"
  url "https://github.com/devmobasa/wayscriber/archive/refs/tags/v0.9.20.tar.gz"
  sha256 "e88f463be9b21dc903ce36e908e037dd5dc6cab12c035f9b7f7d0626ab5107cc"
  license "MIT"

  depends_on "rust" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "pango"
  depends_on "wayland"
  depends_on "libxkbcommon"
  depends_on "vulkan-loader"
  depends_on "mesa" # For libGL

  def install
    # Build and install main wayscriber binary
    system "cargo", "install", *std_cargo_args

    # Build and install configurator
    cd "configurator" do
      system "cargo", "install", *std_cargo_args(path: ".")
    end
    
    # Install documentation and example files
    doc.install "config.example.toml", "README.md", "LICENSE"
    doc.install "packaging/wayscriber.service"
    
    # Note: Desktop files and icons should be installed manually by users
    # as Homebrew doesn't manage user XDG directories
  end

  test do
    assert_match "wayscriber", shell_output("#{bin}/wayscriber --version 2>&1", 1)
  end
end
