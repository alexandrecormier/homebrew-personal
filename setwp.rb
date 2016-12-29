require 'language/go'

class Setwp < Formula
    desc "Command line utility to set wallpaper on Yosemite and up"

    homepage "https://github.com/alexcormier/setwp"
    url "https://github.com/alexcormier/setwp/archive/v1.1.0.tar.gz"
    head "https://github.com/alexcormier/setwp.git"

    sha256 "93ab8e3dd812196c715d7b920c09439090bef4191fd55eeaed567b3fe0463b36"

    bottle do
        cellar :any
        root_url "https://github.com/alexcormier/setwp/releases/download/v1.1.0"
        sha256 "1513b4e2097bf1f77de953971df55f173fde98009ba3223ae0376fb46192ebee" => :yosemite
        sha256 "1513b4e2097bf1f77de953971df55f173fde98009ba3223ae0376fb46192ebee" => :el_capitan
        sha256 "1513b4e2097bf1f77de953971df55f173fde98009ba3223ae0376fb46192ebee" => :sierra
    end

    depends_on :macos => :yosemite
    depends_on "go" => :build

    go_resource "github.com/docopt/docopt-go" do
        url "https://github.com/docopt/docopt-go.git",
        :revision => "784ddc588536785e7299f7272f39101f7faccc3f"
    end

    go_resource "github.com/mattn/go-sqlite3" do
        url "https://github.com/mattn/go-sqlite3.git",
        :revision => "2d44decb4941c9cdf72c22297b7890faf7da9bcb"
    end

    # needed for go-sqlite3
    go_resource "golang.org/x/net" do
        url "https://github.com/golang/net.git",
        :revision => "8fd7f25955530b92e73e9e1932a41b522b22ccd9"
    end

    def install
        ENV["GOPATH"] = buildpath

        mkdir_p buildpath/"src/github.com/alexcormier/"
        ln_s buildpath, buildpath/"src/github.com/alexcormier/setwp"
        Language::Go.stage_deps resources, buildpath/"src"

        system "go", "build", "-o", "setwp"

        bin.install "setwp"
        bash_completion.install 'completion/setwp-completion.bash'
        zsh_completion.install 'completion/setwp-completion.zsh' => '_setwp'
    end

    test do
        assert_equal `#{bin}/setwp --version`.strip, "setwp version #{version}"
    end
end
