EMACS=emacs
FLAGS=-batch --eval="(setq load-path (append '(\".\" load-path)))"

SRC=aasm_mode.el bison-mode.el css-mode.el d-mode.el doxymacs.el	\
epita_comment.el flex-mode.el lua-mode.el make-regexp.el php-mode.el	\
promela.el python-mode.el quack.el rebox.el ruby-mode.el tiger-mode.el	\
xml-parse.el yaml-mode.el

OBJ=$(SRC:.el=.elc)

all: $(OBJ)

.el.elc:
	$(EMACS) $(FLAGS) -f batch-byte-compile $<

clean:
	rm -f $(OBJ)
