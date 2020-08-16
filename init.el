(require 'package)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)



(display-time-mode 1)
(desktop-save-mode 1)
;(set-cursor-color "#ff4a68") 
(setq-default cursor-type 'bar)
(blink-cursor-mode -1)
(global-linum-mode t)
(tool-bar-mode nil)

(setq create-lockfiles nil)

(visual-line-mode t)
(global-visual-line-mode t)

(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

;;(require 'find-file-in-project))

(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
;; (setq search-default-mode #'char-fold-to-regexp)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)


;; complete
(defvar counsel-complete-line-use-git t)
(defun my-line-str (&optional line-end)
 (buffer-substring-no-properties (line-beginning-position)
  (if line-end line-end (line-end-position))    ))
(defun counsel-complete-line-by-grep ()
  "Complete line using text from (line-beginning-position) to (point).
If OTHER-GREP is not nil, we use the_silver_searcher and grep instead."
  (interactive)
  (let* ((cur-line (my-line-str (point)))
         (default-directory (ffip-project-root))
         (keyword (counsel-escape (replace-regexp-in-string "^[ \t]*" "" cur-line)))
         (cmd (cond
               (counsel-complete-line-use-git
                (format "git --no-pager grep --no-color -P -I -h -i -e \"^[ \\t]*%s\" | sed s\"\/^[ \\t]*\/\/\" | sed s\"\/[ \\t]*$\/\/\" | sort | uniq"
                        keyword))
               (t
                (concat  (my-grep-cli keyword (if (counsel-find-quickest-grep) "" "-h")) ; tell grep not to output file name
                         (if (counsel-find-quickest-grep) " | sed s\"\/^.*:[0-9]*:\/\/\"" "") ; remove file names for ag
                         " | sed s\"\/^[ \\t]*\/\/\" | sed s\"\/[ \\t]*$\/\/\" | sort | uniq"))))
         (leading-spaces "")
         (collection (split-string (shell-command-to-string cmd) "[\r\n]+" t)))

         (message "cmd=%s" cmd)
    ;; grep lines without leading/trailing spaces
    (when collection
      (if (string-match "^\\([ \t]*\\)" cur-line)
          (setq leading-spaces (match-string 1 cur-line)))
      (cond
       ((= 1 (length collection))
        (counsel-replace-current-line leading-spaces (car collection)))
       ((> (length collection) 1)
        (ivy-read "lines:"
                  collection
                  :action (lambda (l)
                            (counsel-replace-current-line leading-spaces l))))))))
(global-set-key (kbd "C-x C-l") 'counsel-complete-line-by-grep)

;; for use latex
(require 'org2ctex)
(org2ctex-toggle t)
;; #+LATEX_HEADER: \usepackage{ctex}

;;ledger
(require 'ledger-mode)

;;(add-hook 'org-mode-hook 'org-indent-mode)
;; org-journal
(require 'org-journal)
(customize-set-variable 'org-journal-dir "/Users/secwang/workspace/org/journal")
(customize-set-variable 'org-journal-date-format "%Y-%m-%d")

(customize-set-variable 'org-journal-file-type 'yearly)


;; auto-save mode
(setq auto-save-file-name-transforms
  `((".*" "~/.emacs-saves/" t)))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   '("~/workspace/org/routine.org" "~/workspace/org/agenda.org"))
 '(package-selected-packages
   '(use-package org-roam-server org-roam colemak-evil evil q-mode find-file-in-project ledger-mode org-download org-noter centaur-tabs alarm-clock dired-launch emojify magit autopair org-journal howm deft wolfram-mode expand-region cnfonts emms easy-kill org-brain org2ctex ivy)))
    ;;pdf-tools 
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; add package

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)


;; emms
(setq exec-path (append exec-path '("/usr/local/bin")))
(require 'emms-setup)
(emms-all)
(emms-default-players)


(setq emms-source-file-default-directory "/Users/secwang/workspace/Music/music")

;;add mpv to emacs list
(setq emms-player-base-format-list
  '("ogg" "mp3" "wav" "mpg" "mpeg" "wmv" "wma"
    "mov" "avi" "divx" "ogm" "ogv" "asf" "mkv"
    "rm" "rmvb" "mp4" "flac" "vob" "m4a" "ape"
    "flv" "webm" "aif" "dsf" "opus"))

(emms-player-set emms-player-mpv 'regex
                 (apply #'emms-player-simple-regexp emms-player-base-format-list))

;; org-mode table 对中文可用
(require 'cnfonts)


;; expand region
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)



;; org table 中英对齐
(set-face-attribute 'default nil :family "Sarasa Mono CL")

;;(set-face-attribute 'org-table nil :family "Sarasa Term TC")

;; ident 
(global-set-key (kbd "C->") 'indent-rigidly-right-to-tab-stop)
(global-set-key (kbd "C-<") 'indent-rigidly-left-to-tab-stop)



;; org-babel

;;(load "~/.emacs.d/package/ob-mathematica.el")
;;(require 'ob-mathematica.el) 
(setq org-confirm-babel-evaluate nil)
(org-babel-do-load-languages
   'org-babel-load-languages
      '(
      (mathematica . t)
      (calc . t)
      (dot . t)
      (shell . t)
      ))

(setq org-confirm-babel-evaluate nil)
;; deft

(setq deft-extension "org")
(setq deft-text-mode 'org-mode)
(setq deft-use-filename-as-title t)
(setq deft-auto-save-interval 0)
(setq deft-recursive t)
(setq deft-use-filter-string-for-filename t)
(setq deft-directory "/Users/secwang/workspace/org/deft")


(global-set-key (kbd "<f8>") 'deft)
(global-set-key (kbd "<f7>") 'deft-find-file)
(setq deft-file-naming-rules '((noslash . "-")
                                   (nospace . "-")
                                   (case-fn . downcase)))
(setq deft-strip-summary-regexp
        (concat "\\("
                "[\n\t]" ;; blank
                "\\|^#\\+[[:upper:]_]+:.*$" ;; org-mode metadata
                "\\|^#\\+[[:alnum:]_]+:.*$" ;; org-mode metadata
                "\\)"))

;;change backup directory

(setq backup-directory-alist `(("." . "~/emacs/saves")))


;; org to opml
(let ((default-directory  "~/.emacs.d/package/"))
  (setq load-path
        (append
         (let ((load-path  (copy-sequence load-path))) ;; Shadow
           (append
            (copy-sequence (normal-top-level-add-to-load-path '(".")))
            (normal-top-level-add-subdirs-to-load-path)))
         load-path)))
(load-library "org-opml")
;;org capture
(global-set-key (kbd "<f6>") 'org-capture)

(setq org-capture-templates
 '(
   ("t" "TODO" entry (file+olp+datetree 
                            "/Users/secwang/workspace/org/agenda.org") 
    "* TODO %? \n"
    ) 
;;      ("j" "[J]ournal" entry (file+olp+datetree"/Users/secwang/workspace/org/journal.org")
;;       "** %<%H:%M> %?\n" :time-prompt t)
      ("d" "[d]iary" entry (file+olp+datetree"/Users/secwang/workspace/org/diary.org")
       "** %<%H:%M> %?\n" :time-prompt t)

   ("o" "[o]pportunity" entry (file+olp+datetree 
                          "/Users/secwang/workspace/org/opportunity.org" ) 
    "** %<%H:%M> %?\n" )

   ("l" "Trade[l]og" entry (file+datetree+prompt
                          "/Users/secwang/workspace/org/tradelog.org" ) 
    "** %<%H:%M> %?\n")

   ;;("l" "Log Time" entry (file+olp+datetree 
    ;;                      "/Users/secwang/workspace/org/logtime.org" ) 
   ;; "** %U - %^{Activity}  :TIME:")
   ))




;; org agenda
 (global-set-key "\C-cb" 'org-switchb)
 (global-set-key (kbd "C-x g") 'magit-status)

(setq org-todo-keywords
      '((sequence "INACTIVE" "TODO" "NEXT" "DONE" )))
(setq org-log-done 'time)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "<f9>") 'org-journal-new-entry)
(global-set-key (kbd "<f10>") 'calendar)

(setq-default org-display-custom-times t)
(setq org-time-stamp-custom-formats '("<%Y-%m-%d %A>" . "<%Y-%m-%d %A %H:%M>"))

;;emojify
;;(add-hook 'after-init-hook #'global-emojify-mode)

;;org image
(setq org-startup-with-inline-images t)

;; org  habits
(setq org-modules (quote (org-habit)))

;; dired launch
(dired-launch-enable)
;; Open files in dired mode using 'open'
(eval-after-load "dired"
  '(progn
     (define-key dired-mode-map (kbd "z")
       (lambda () (interactive)
         (let ((fn (dired-get-file-for-visit)))
           (start-process "default-app" nil "open" fn))))))
;; gls
(let ((gls "/usr/local/bin/gls"))
  (if (file-exists-p gls) (setq insert-directory-program gls)))


(when (or window-system (daemonp))
  (setq default-frame-alist '(
                              (height . 47) (width . 90) (left . 1732) (top . 520)
 ))
)


;; pdf tools 
;;brew install homebrew/emacs/pdf-tools
;;(setq pdf-info-epdfinfo-program "/usr/local/bin/epdfinfo")
;;(add-hook 'pdf-view-mode-hook (lambda() (linum-mode -1)))
;;(setq pdf-view-incompatible-modes 'linum-mode)
;;(pdf-tools-install)


;;(alarm-clock--turn-autosave-on)


;; enable tramp

(setq tramp-default-method "ssh")



;; centaur-tabs
;;(require 'centaur-tabs)
;;(centaur-tabs-mode t)
;;(global-set-key (kbd "C-<prior>")  'centaur-tabs-backward)
;;(global-set-key (kbd "C-<next>") 'centaur-tabs-forward)


;; org -download
(setq org-startup-with-inline-images t)

(setq org-image-actual-width nil)
(require 'org-download)
(setq org-download-image-org-width 600)
(setq org-download-image-html-width 600)
(setq org-download-image-latex-width 600)
;;(org-download-screenshot-method "screencapture -i %s")
(add-hook 'dired-mode-hook 'org-download-enable)

(setq-default org-download-image-dir "~/Pictures/org_images")
;; open png in preview
(add-hook 'org-mode-hook
      '(lambda ()
         (setq org-file-apps
           '((auto-mode . emacs)
             ("\\.png\\'" . default)
             ("\\.mm\\'" . default)
             ("\\.x?html?\\'" . default)
             ("\\.pdf\\'" . "evince %s")))))


;; Drag-and-drop to `dired`
;; calendar
(require 'calendar)
(setq calendar-date-style 'iso)
;;(setq calendar-date-display-form  '((format "%s-%.2d-%.2d" year (string-to-number month)
;;              (string-to-number day))))

(setq calendar-week-start-day 7 
      calendar-view-diary-initially-flag t
      calendar-mark-diary-entries-flag t)
(add-hook 'diary-display-hook 'fancy-diary-display)
(add-hook 'today-visible-calendar-hook 'calendar-mark-today)
(add-hook 'list-diary-entries-hook 'sort-diary-entries t)


;; timeclock
(require 'timeclock-x)

(setq timeclock-file "/Users/secwang/workspace/org/timelog.ledger")
(timeclock-modeline-display 1)
(global-set-key (kbd "C-x t i") 'timeclock-in-safe)
(global-set-key (kbd "C-x t o") 'timeclock-out-safe)
(global-set-key (kbd "C-x t t") 'timeclock-visit-timelog)
(global-set-key (kbd "C-x t r") 'timeclock-generate-report)

;; evil
(require 'evil)
(evil-mode 1)

;; org-roam
(use-package org-roam
      :ensure t
      :hook
      (after-init . org-roam-mode)
      :custom
      (org-roam-directory "/Users/secwang/workspace/org/roam")
      :bind (:map org-roam-mode-map
              (("C-c n l" . org-roam)
               ("C-c n f" . org-roam-find-file)
               ("C-c n g" . org-roam-graph-show))
              :map org-mode-map
              (("C-c n i" . org-roam-insert))
              (("C-c n I" . org-roam-insert-immediate))))

(use-package org-roam-server
  :ensure t
  :config
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 8080
        org-roam-server-authenticate nil
        org-roam-server-export-inline-images t
        org-roam-server-serve-files nil
        org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
        org-roam-server-network-poll t
        org-roam-server-network-arrows nil
        org-roam-server-network-label-truncate t
        org-roam-server-network-label-truncate-length 60
        org-roam-server-network-label-wrap-length 20))

(require 'org-roam-protocol)







