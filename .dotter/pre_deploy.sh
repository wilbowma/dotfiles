#!/bin/sh

## Detect dotter issues
## ------------------------------------------------------------------------

if [ ! -e ~/webdav/dotfiles/.dotter/`hostname`.toml ]; then
   echo "Please configure $(hostname).toml; press any key to continue"
   read
fi

## Detect veracrypt
## ------------------------------------------------------------------------

if [ ! -d ~/webdav/dotfiles/secure/ssh ]; then
  echo "Make sure to mount secure archive. Example commands:"
  echo ""
  echo "veracrypt archive secure"
  echo "/Applications/VeraCrypt.app/Contents/MacOS/VeraCrypt archive secure"
  echo ""
  echo "On Linux, you may need to force mounting as rewritable:"
  echo "mount -t hfsplus -o force,rw secure"
  echo "If it fails, run fsck on the volume and retry."
  echo "Press any key to continue."
  read
fi

## Spacemacs install
## ------------------------------------------------------------------------

if [ ! -e ~/.emacs.d ]; then
    git clone --single-branch --depth 1 https://github.com/syl20bnr/spacemacs ~/.emacs.d
fi

## LanguageTool setup
## ------------------------------------------------------------------------

if [ `uname -s` = "Darwin" ]; then
    LANGUAGE_TOOL_DICT_PATH="/usr/local/Cellar/languagetool/*/libexec/org/languagetool/resource/en/hunspell/spelling_custom.txt"
    LANGUAGE_TOOL_GRAMMAR_PATH=$(ls /usr/local/Cellar/languagetool/*/libexec/org/languagetool/rules/en/grammar.xml)
fi
if [ `uname -s` = "Linux" ]; then
    LANGUAGE_TOOL_DICT_PATH="/usr/share/languagetool/org/languagetool/resource/en/hunspell/spelling_custom.txt"
    LANGUAGE_TOOL_GRAMMAR_PATH=/usr/share/languagetool/org/languagetool/rules/en/grammar.xml
fi

if [ ! -L "$LANGUAGE_TOOL_DICT_PATH" ]; then
    echo "Patching langtool dictionary; require sudo elevation."
    sudo ln -sf ~/.aspell.en.pws "$LANGUAGE_TOOL_DICT_PATH"
fi

if patch --force --dry-run -p1 $LANGUAGE_TOOL_GRAMMAR_PATH ~/webdav/dotfiles/.dotter/language-tool-rules.patch; then
    sed -i "s|HOME|$HOME|" ~/webdav/dotfiles/.dotter/language-tool-rules.patch
    echo "Patching grammar.xml; require sudo elevation."
    sudo patch -p1 $LANGUAGE_TOOL_GRAMMAR_PATH ~/webdav/dotfiles/.dotter/language-tool-rules.patch || true
fi
