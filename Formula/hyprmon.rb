class Hyprmon < Formula
  desc "TUI monitor configuration tool for Hyprland with visual layout, drag-and-drop, and profile management"
  homepage "https://github.com/erans/hyprmon"
  url "https://github.com/erans/hyprmon/archive/refs/tags/v0.0.12.tar.gz"
  sha256 "ffeff85e8a700273fa2bf00cc067534af84b39c860ce5445bd345b0281eab96c"
  license "MIT"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match "hyprmon", shell_output("#{bin}/hyprmon --help")
  end
end

