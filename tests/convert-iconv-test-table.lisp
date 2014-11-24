(in-package :cl-user)

(ql:quickload :split-sequence)

;; e.g. (convert-hex-to-sequence "0xCAFE") => (#xCA #xFE)
(defun convert-hex-to-sequence (hex)
  (loop for i from 2 below (length hex) by 2
        collect (parse-integer hex :start i :end (+ i 2) :radix 16)))

(defun read-iconv-test-table (path-in)
  (with-open-file (in path-in :direction :input)
    (loop for line = (read-line in nil nil) while line
          collect (mapcar #'convert-hex-to-sequence
                          (split-sequence:split-sequence #\Tab line)))))

;; e.g. (convert-file "~/src/lisp/babel/tests/cp949.txt"
;;                    "~/src/lisp/babel/tests/cp949.sexp")
(defun convert-file (path-in path-out)
  (let ((table (read-iconv-test-table path-in)))
    (with-open-file (out path-out :direction :output)
      (write-line ";; -*- mode: lisp -*-" out)
      (with-standard-io-syntax
        (pprint table out)))))
