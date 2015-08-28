require 'language/go'

class Setwp < Formula
    desc "Command line utility to set wallpaper on Yosemite"

    homepage "https://github.com/alexandrecormier/setwp"
    url "https://github.com/alexandrecormier/setwp/archive/v1.0.2.tar.gz"
    head "https://github.com/alexandrecormier/setwp.git"

    sha256 "e35f68bb0abeb3e7762469bac1eb42d1bad7bc428265a219417cc2ad1b83b0d9"

    bottle do
        cellar :any
        root_url "https://github.com/alexandrecormier/setwp/releases/download/v1.0.2"
        sha256 "5a9b7071e95c9b99a726b52f8fd64c78a555324650b446f10b42796868b46dfb" => :yosemite
    end

    depends_on :macos => :yosemite
    depends_on "go" => :build

    go_resource "github.com/docopt/docopt-go" do
        url "https://github.com/docopt/docopt-go.git",
        :revision => "854c423c810880e30b9fecdabb12d54f4a92f9bb"
    end

    go_resource "github.com/mattn/go-sqlite3" do
        url "https://github.com/mattn/go-sqlite3.git",
        :revision => "8897bf145272af4dd0305518cfb725a5b6d0541c"
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
