;;; ces-repl.el --- REPL for Emacs Game Engine  -*- lexical-binding: t -*-

;; Copyright (C) 2018 Alexander Griffith
;; Author: Alexander Griffith <griffitaj@gmail.com>
;; Version: 0.1.0
;; Package-Requires: ((emacs "25.1"))
;; Homepage: https://github.com/alexjgriffith/ces.el

;; This file is not part of GNU Emacs.

;; This file is part of ces.el.

;; ces.el is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; ces.el is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with ces.el.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; See `ces-repl-test' for a sample implementation.

;;; Code:

(defvar ces-repl-line-number 0 "The current evaluation line.")
(make-variable-buffer-local 'ces-repl-line-number)

(defvar ces-repl-line-mark  ">" "Line start marker for the REPL>")

(defvar ces-repl-name  "*ces-repl*" "Default repl name.")

(defvar ces-repl-error-message "WARNING: generic error!!"
"A generic error message for those that are not handled.
Set to nil to see raw emacs error signals.")

(defvar ces-repl-history nil
  "A list of strings representing historical commands.")
(make-variable-buffer-local 'ces-repl-history)

(defvar ces-repl-future nil
  "A list of strings representing future commands.")
(make-variable-buffer-local 'ces-repl-future)

(defvar ces-repl-test-highlights  
  `(("|\\|> " . font-lock-constant-face))
  "Default repl highlights.")
(make-variable-buffer-local 'ces-repl-test-highlights)

(defvar ces-repl-test-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "RET") #'ces-repl-enter)
    (define-key map (kbd "M-p") #'ces-repl-insert-previous)
    (define-key map (kbd "M-n") #'ces-repl-insert-next)
    (define-key map (kbd "C-a") #'ces-repl-move-beginning-of-line)
    map)
  "Default key mapping for ces-repl-test-mode.")

(defvar ces-repl-functions #s(hash-table test equal data ())
  "Holds the functions needed for the interpreter")
(make-variable-buffer-local 'ces-repl-test-highlights)

(defvar ces-repl-function-terminations '("\n" ";")
  "REPL termination markers.")

(defvar ces-repl-function-pipe '("|")
  "REPL pipe marker.
Note the result before the pipe is passed as the first argument to
the function following the pipe.")

(define-derived-mode ces-repl-test-mode text-mode "REPL"
  "Major mode for toy repl meant for the 2018 lisp game jam."
  (setq font-lock-defaults '(ces-repl-test-highlights)))

(defun ces-repl-load-functions(fun-alist)
  "Load the FUN-ALIST into `ces-repl-functions'."
  (mapc (lambda(fun-pair)
          (puthash (car fun-pair) (cdr fun-pair) ces-repl-functions))
        fun-alist))

(defun ces-repl-add-function-keywords(fun-alist)
  "Add the FUN-ALIST function names to into `ces-repl-test-highlights'."
  (push (cons (mapconcat 'car fun-alist "\\|") 'font-lock-function-name-face)
        ces-repl-test-highlights))

(defun ces-repl-test ()
  "Start a new repl with some test functions."
  (interactive)
  (let ((buffer (get-buffer-create "*ces-repl-test*"))        
        (fun-alist '(("concat0" . concat)
                     ("concat" . (lambda(&rest body) (mapconcat 'identity
                                                                body " ")))
                    ("echo" . identity)
                    ("add" . (lambda(a b)
                               (format "%s"
                                (+ (if (stringp a) (string-to-number a) a)
                                  (if (stringp b) (string-to-number b) b)))))
                    ("commands" . (lambda (&rest _body)
                                    (mapconcat 'identity
                                               '("commands/0" "concat/n" "concat0/2" "echo/1" "add/2")
                                               " "))))))
    (with-current-buffer  buffer
      (ces-repl buffer)
      (ces-repl-add-function-keywords fun-alist)
      (ces-repl-load-functions fun-alist)            
      (font-lock-add-keywords nil ces-repl-test-highlights)
      (switch-to-buffer-other-window buffer))))

(defun ces-repl (&optional repl-buffer)
  "Create a new ces-repl with optional name REPL-NAME."
  (with-current-buffer (or repl-buffer (get-buffer-create  ces-repl-name))
    (ces-repl-new-line t)
    (ces-repl-test-mode)
    (current-buffer)))

(defun ces-repl-enter ()
  "Read, Evaluate and Print the current command line."
  (interactive)
  (let* ((line (ces-repl-read-line))
         (err nil)
         (str (condition-case error
                  (ces-repl-interp (ces-repl-parse-line line))
                (void-function (setq err "No matching function."))
                (wrong-number-of-arguments (setq err "Wrong number of arguments."))
                (wrong-type-argument (setq err "Type mismatch."))
                (error (setq err (or error ces-repl-error-message))))))
    (ces-repl-store-line-history line)
    (re-search-forward "$")
    (if err
        (insert (format "\n%s" err ))
      (when str
        (insert (format "\n%s" str))))
    (ces-repl-new-line)))

(defun ces-repl-store-line-history (line)
  "Push LINE to `ces-repl-history'"
  (push line ces-repl-history) )

(defun ces-repl-store-line-future (line)
  "Push LINE to `ces-repl-future'"
  (push line ces-repl-future))

(defun ces-repl-insert-previous ()
  "Insert the previous command in future.
The current command is stored in the future"
  
  (interactive)
  (let ((current (pop ces-repl-history)))    
    (when current
      (ces-repl-store-line-future (ces-repl-read-line))
      (ces-repl-delete-current-line)
      (insert current))))

(defun ces-repl-insert-next ()
  "Insert the next command in future.
The current command is stored in the history"
  (interactive)
  (let ((current (pop ces-repl-future)))    
    (when current
      (ces-repl-store-line-history (ces-repl-read-line))
      (ces-repl-delete-current-line)
      (insert current))))


(defun ces-repl-delete-current-line ()
  "Delete the current command line."
  (let ((start (ces-repl-goto-start-current-line))
        (end (re-search-forward "$")))
    (delete-region start end)))

(defun ces-repl-new-line (&optional no-newline)
  "Add a repl new command line.
If NO-NEWLINE is non nil, do not add the marker but not a newline"
  (interactive)
  (setq ces-repl-line-number (+ ces-repl-line-number 1))
  (insert (concat (unless no-newline  "\n" )                  
                  (propertize(concat  ces-repl-line-mark) 'new-command-line t)
                  (propertize " " 'line-start t 'line-number ces-repl-line-number))))

(defun ces-repl-move-beginning-of-line ()
  "Go to the start of a the command line."
  (interactive)
  (move-beginning-of-line nil)
  (when (member 'new-command-line (text-properties-at (point)))
    (goto-char (+ (point) 2))))

(defun ces-repl-goto-start-current-line ()
  "Search for the start of a the command line."
  (previous-single-property-change (point) 'new-command-line))

(defun ces-repl-parse-line (str)
  "Tokenize the input string STR.
The string is just split at spaces."
  (split-string  str  " " t))

(defun ces-repl-read-line ()
  "Read the last command line of the buffer."
  (save-excursion
    (let (err
          (end (goto-char (point-max)))
          (start (condition-case nil
                     (ces-repl-goto-start-current-line)
                   (error (setq err t)))))
      (if start          
          (buffer-substring-no-properties start end)
        ""))))

(defun ces-repl-interp (tokens)
  " Interpret TOKENS based on `ces-repl-functions'.
The first token is the function handle the remaining tokens until \n ; or | 
are arguments.
\n or ; end the call, any token after this point is ignored
| marks the start of a new function. The new function takes the output 
of the previous function as its first argument

implementation details: 
> concat hello world! | echo
(echo world | echo)
echo -> lookup the echo function
(funcall (gethash \"concat\" functions) \"hello\")
(funcall (gethash \"concat\" functions) \"hello\" \"world\")
keep adding variables to the end of funcall until \n ; or |
upon \n ; or | eval the function and save it in ret
if | and there is another arg
(funcall (gethash \"echo\") var)

TODO: implement escape character to permit multiline calls."
  (let ((token (pop tokens))
        (state 'function)
        fun
        args
        ret)
    (while token
      (cond ((eq state 'function)
               (setq fun (gethash token ces-repl-functions))
               (setq state 'arg))
            ((eq state 'arg)
             (cond  ((member token ces-repl-function-terminations)
                     (setq ret (apply fun (nreverse args)))
                     (setq state 'termination))
                    ((member token ces-repl-function-pipe)
                     (setq ret (apply fun (nreverse args)))
                     (setq args (list ret))
                     (setq state 'function))
                    (t
                     (push token args))))
            ((eq state 'termination) nil))
      (setq token (pop tokens)))
    (cond ((or (eq state 'termination) (eq state 'function))
           ret)
          ((eq state 'arg)
           (apply fun (nreverse args))))))


(provide 'ces-repl)
;;; ces-repl.el ends here
