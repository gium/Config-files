;;
;; w3-conf.el for  in /u/guest/dp/users/asega/public/emacsW3/conf
;; 
;; Made by gestion domaine public
;; Login   <dp@epita.fr>
;; 
;; Started on  Sun May 11 05:54:12 2003 gestion domaine public
;; Last update Sun May 11 06:27:01 2003 gestion domaine public
;;


;; it's the same, old conf !

(setq load-path                                                              
      (push                                                                  
       "/u/guest/dp/public/emacsW3/share/emacs/site-lisp/" 
       load-path))


;; On invoque le package w3 et on set une conf par defaut,
;; au moins pour ce qui doit passer ou pas a travers le proxy.

(require 'w3)

(setq url-proxy-services
      '(("http"     . "proxy.epi.net:3129")
	("ftp"     . "proxy.epi.net:3129")
	("no_proxy" . "^.*\\(epita.fr\\|epitech.net\\)")))





