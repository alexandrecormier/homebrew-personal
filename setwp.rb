require 'language/go'

class Setwp < Formula
    desc "Command line utility to set wallpaper on Yosemite"

    homepage "https://github.com/alexandrecormier/setwp"
    url "https://github.com/alexandrecormier/setwp/archive/v1.0.3.tar.gz"
    head "https://github.com/alexandrecormier/setwp.git"

    sha256 "87602e6e598522a86c4d7abe69e5d073fd438904ee44022ba29bd9b79e72e84b"

    bottle do
        cellar :any
        root_url "https://github.com/alexandrecormier/setwp/releases/download/v1.0.3"
        sha256 "86148dedd9f8fdbf0497008f04cd49820c96d9062e563a21022a5a9bb5b4d588" => :yosemite
    end

    depends_on :macos => :yosemite
    depends_on "go" => :build

    go_resource "github.com/docopt/docopt-go" do
        url "https://github.com/docopt/docopt-go.git",
        :revision => "854c423c810880e30b9fecdabb12d54f4a92f9bb"
    end

    go_resource "github.com/mattn/go-sqlite3" do
        url "https://github.com/mattn/go-sqlite3.git",
        :revision => "897b8800a7d1a93518b87c00e5d1c5d7476f3701"
    end

    def install
        ENV["GOPATH"] = buildpath

        mkdir_p buildpath/"src/github.com/alexandrecormier/"
        ln_s buildpath, buildpath/"src/github.com/alexandrecormier/setwp"
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
