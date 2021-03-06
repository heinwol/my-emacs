;; my-main.el -*- lexical-binding: t -*-
(setq lexical-binding t)

(defun duplicate-line-down()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank))

(defun duplicate-line-up()
  "WIP, don't touch!"
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank))

;;(global-set-key (kbd "M-<down>") 'duplicate-line-down)





(defun copy-file-path ()
  "Copies selected file's path to clipboard."
  (interactive)
  (let ((filename (if (derived-mode-p 'dired-mode)
                      (dired-get-filename)
                      (buffer-file-name))))
    (when filename
      (with-temp-buffer
        (insert filename)
        (clipboard-kill-region (point-min) (point-max)))
      (message filename))))


(add-hook 'dired-mode-hook
	  (lambda () (local-set-key (kbd "C-c C-p") 'copy-file-path)))


(defun jn ()
  "Calls jupyter notebook in external terminal if in dired/sunrise."
  (interactive)
  (when (derived-mode-p 'dired-mode)
    (shell-command "start jupyter notebook")))






(require 'dired-aux)

;; (setq dired-guess-shell-alist-user
;;       '(("\\.pdf\\'" "evince")
;;         ("\\.eps\\'" "evince")
;;         ("\\.jpe?g\\'" "eog")
;;         ("\\.png\\'" "eog")
;;         ("\\.gif\\'" "eog")
;;         ("\\.tex\\'" "pdflatex" "latex")
;;         ("\\.\\(?:mp4\\|mkv\\|avi\\|flv\\)\\'" "vlc")))

(defvar dired-filelist-cmd
  '(("vlc" "-L")))
(defun dired-start-process (cmd &optional file-list)
  (interactive
   (let ((files (dired-get-marked-files t current-prefix-arg)))
     (list
      (dired-read-shell-command "& on %s: " current-prefix-arg files)
      files)))
  (apply
   #'start-process
   (list cmd nil shell-file-name shell-command-switch
         (format "nohup 1>/dev/null 2>/dev/null %s \"%s\""
                 (if (> (length file-list) 1)
                     (format "%s %s"
                             cmd
                             (cadr (assoc cmd dired-filelist-cmd)))
                     cmd)
                 (mapconcat #'expand-file-name file-list "\" \"")))))

(add-hook 'dired-mode-hook
	  (lambda () (local-set-key (kbd "<C-return>") 'dired-start-process)))


;;;;;


(defun reload-current-file ()
  (interactive)
  (let* ((fname (buffer-file-name)))
    (if (string-equal "el" (file-name-extension fname))
	(load-file fname)
      (revert-buffer))))
;;(message "Currently not editing .el file!")


(add-hook 'emacs-lisp-mode-hook
	  (lambda () (local-set-key (kbd "C-c C-r") 'reload-current-file)))



(setq window-state-before-sunrise nil)

(global-set-key
 [(control ?~) ]
 (lambda ()
   (interactive)
   (if (derived-mode-p 'sunrise-mode)
       (progn
	 (sunrise-cd)
	 (when window-state-before-sunrise
	   (set-window-configuration
	    window-state-before-sunrise)))
     (progn
       (setq window-state-before-sunrise
	     (current-window-configuration))
       (sunrise-cd)))))


;; (global-set-key (kbd "C-` C-<left>") 'shrink-window-horizontally)
;;     (global-set-key (kbd "C-` C-<right>") 'enlarge-window-horizontally)
;;     (global-set-key (kbd "C-` C-<down>") 'shrink-window)
;;     (global-set-key (kbd "C-` C-<up>") 'enlarge-window)


(defun find-first-non-ascii-char ()
  "Find the first non-ascii character from point onwards."
  (interactive)
  (let (point)
    (save-excursion
      (setq point
            (catch 'non-ascii
              (while (not (eobp))
                (or (eq (char-charset (following-char))
                        'ascii)
                    (throw 'non-ascii (point)))
                (forward-char 1)))))
    (if point
        (goto-char point)
        (message "No non-ascii characters."))))


(setq sunrise-attributes-display-mask '(nil nil nil nil t t t))

(provide 'my-main)
;;; my-main.el ends here
