;;; q-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "q-mode" "q-mode.el" (0 0 0 0))
;;; Generated autoloads from q-mode.el

(autoload 'q "q-mode" "\
Start a new q process.
The optional argument HOST and USER allow the q process to be
started on a remoate machine.  The optional ARGS argument
qspecifies the command line args to use when executing q; the
default ARGS are obtained from the q-init customization
variables.

In interactive use, a prefix argument directs this command
to read the command line arguments from the minibuffer.

\(fn &optional HOST USER ARGS)" t nil)

(autoload 'q-qcon "q-mode" "\
Connect to a pre-existing q process.
Optional argument ARGS specifies the command line args to use
when executing qcon; the default ARGS are obtained from the
`q-host' and `q-init-port' customization variables.

In interactive use, a prefix argument directs this command
to read the command line arguments from the minibuffer.

\(fn &optional ARGS)" t nil)

(autoload 'q-shell-mode "q-mode" "\
Major mode for interacting with a q interpreter

\(fn)" t nil)

(autoload 'q-mode "q-mode" "\
Major mode for editing q language files

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("\\.[kq]\\'" . q-mode))

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "q-mode" '("q-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; q-mode-autoloads.el ends here
