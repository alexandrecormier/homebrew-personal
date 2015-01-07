require 'formula'

class Stderred < Formula
    homepage 'https://github.com/sickill/stderred'
    head 'https://github.com/sickill/stderred.git'

    depends_on 'cmake' => :build

    def install
        ENV.universal_binary if OS.mac?
        mkdir 'build' do
            system "cmake", '../src', *std_cmake_args
            system 'make', 'install'
        end
    end

    def caveats; <<-EOS.undent
        To use stderred add the following to your .bashrc/.zshrc:
            brew_prefix="$(brew --prefix)"
            stderr_binary="$brew_prefix/lib/libstderred.dylib"
            [ -f $stderred_binary ] && export DYLD_INSERT_LIBRARIES="$stderred_binary${DYLD_INSERT_LIBRARIES:+:DYLD_INSERT_LIBRARIES}"
        EOS
    end
end
