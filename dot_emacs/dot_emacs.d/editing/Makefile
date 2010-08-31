EMACS=emacs
FLAGS=-batch

SRC=boxquote.el thinks.el
OBJ=$(SRC:.el=.elc)

all: $(OBJ)

.el.elc:
	$(EMACS) $(FLAGS) -f batch-byte-compile $<

clean:
	rm -f $(OBJ)
