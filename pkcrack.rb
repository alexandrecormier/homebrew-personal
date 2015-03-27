require 'formula'

class Pkcrack < Formula
    homepage 'https://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack.html'
    url 'https://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack/pkcrack-1.2.2.tar.gz'
    sha256 '4d2dc193ffa4342ac2ed3a6311fdf770ae6a0771226b3ef453dca8d03e43895a'

    option 'with-prefix', "Adds 'pk_' prefix to binaries"

    def install
        inreplace 'src/exfunc.c', '#include <malloc.h>', ''
        inreplace 'src/extract.c', '#include <malloc.h>', ''
        inreplace 'src/main.c', '#include <malloc.h>', ''
        inreplace 'src/readhead.c', '#include <malloc.h>', ''
        inreplace 'src/zipdecrypt.c', '#include <malloc.h>', ''

        system 'make', '-C', 'src', 'all', "CC=#{ENV.cc}"

        prefix = (build.with? 'prefix') ? 'pk_' : ''

        if build.with? 'prefix'
            mv 'src/pkcrack', "src/#{prefix}pkcrack"
            mv 'src/findkey', "src/#{prefix}findkey"
            mv 'src/zipdecrypt', "src/#{prefix}zipdecrypt"
            mv 'src/extract', "src/#{prefix}extract"
            mv 'src/makekey', "src/#{prefix}makekey"
        end

        bin.install "src/#{prefix}pkcrack"
        bin.install "src/#{prefix}findkey"
        bin.install "src/#{prefix}zipdecrypt"
        bin.install "src/#{prefix}extract"
        bin.install "src/#{prefix}makekey"

        doc.install Dir['doc/*']
    end
end
