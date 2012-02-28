EMACS=emacs
FLAGS=-batch -l dot_emacs.d/lpath.el

MAIN_SRC=dot_emacs.d/my-editing.el dot_emacs.d/my-gnus.el	\
dot_emacs.d/my-misc.el dot_emacs.d/my-programming.el		\
dot_emacs.d/my-writing.el
EDITING_SRC=dot_emacs.d/editing/boxquote.el	\
dot_emacs.d/editing/thinks.el
GNUS_SRC=dot_emacs.d/gnus/cersti-photo.el	\
dot_emacs.d/gnus/gnus-stat.el
MISC_SRC=dot_emacs.d/misc/mpcel.el dot_emacs.d/misc/yic.el
PROGRAMMING_SRC= dot_emacs.d/programming/aasm_mode.el			\
dot_emacs.d/programming/bison-mode.el					\
dot_emacs.d/programming/css-mode.el dot_emacs.d/programming/d-mode.el	\
dot_emacs.d/programming/doxymacs.el					\
dot_emacs.d/programming/epita_comment.el				\
dot_emacs.d/programming/flex-mode.el					\
dot_emacs.d/programming/lua-mode.el					\
dot_emacs.d/programming/make-regexp.el					\
dot_emacs.d/programming/php-mode.el dot_emacs.d/programming/promela.el	\
dot_emacs.d/programming/python-mode.el					\
dot_emacs.d/programming/quack.el dot_emacs.d/programming/rebox.el	\
dot_emacs.d/programming/ruby-mode.el					\
dot_emacs.d/programming/tiger-mode.el					\
dot_emacs.d/programming/xml-parse.el					\
dot_emacs.d/programming/yaml-mode.el					\
dot_emacs.d/programming/haskell-mode/haskell-cabal.el			\
dot_emacs.d/programming/haskell-mode/haskell-c.el			\
dot_emacs.d/programming/haskell-mode/haskell-decl-scan.el		\
dot_emacs.d/programming/haskell-mode/haskell-doc.el			\
dot_emacs.d/programming/haskell-mode/haskell-font-lock.el		\
dot_emacs.d/programming/haskell-mode/haskell-ghci.el			\
dot_emacs.d/programming/haskell-mode/haskell-hugs.el			\
dot_emacs.d/programming/haskell-mode/haskell-indent.el			\
dot_emacs.d/programming/haskell-mode/haskell-mode.el			\
dot_emacs.d/programming/haskell-mode/haskell-simple-indent.el		\
dot_emacs.d/programming/haskell-mode/haskell-site-file.el		\
dot_emacs.d/programming/haskell-mode/inf-haskell.el			\
dot_emacs.d/programming/tuareg-mode/append-tuareg.el			\
dot_emacs.d/programming/tuareg-mode/camldebug.el			\
dot_emacs.d/programming/tuareg-mode/custom-tuareg.el			\
dot_emacs.d/programming/tuareg-mode/sym-lock.el				\
dot_emacs.d/programming/tuareg-mode/tuareg.el
dot_emacs.d/WRITING_SRC=

SRC=$(MAIN_SRC) $(EDITING_SRC) $(GNUS_SRC) $(MISC_SRC)	\
$(PROGRAMMING_SRC) $(WRITING_SRC)
OBJ=$(SRC:.el=.elc)

all: auctex $(OBJ)
	echo $(OBJ)

.el.elc:
	$(EMACS) $(FLAGS) -f batch-byte-compile $<

auctex:
	(cd dot_emacs.d/writing/auctex && ./configure && make) || exit 0
