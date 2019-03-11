;;; asl-mode.el --- minor mode for editting ASL files     -*- lexical-binding: t; -*-

;; Copyright (C) 2015 Curt Brune

;; Author: Curt Brune <curt@cumulusnetworks.com>
;; Keywords: languages, files

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Minor emacs mode for editting .asl and .asli files (ACPI includes)

;; Copy this file to $HOME/.emacs.d/asl-mode.el and reload.

(provide 'asl-mode)

(define-generic-mode
    'asl-mode ;; name of mode
  '("//"  ;; comments start with //
    ("/*" . "*/"))  ;; comments start with /*, end with */
  '("Scope"
    "Device"
    "Name"
    "Method"
    "Return"
    "Package"
    "GpioIo"
    "I2cSerialBus"
    "ToUUID"
    "Unicode"
    "ResourceTemplate"
    ) ;; some keywords
  '(("=" . 'font-lock-builtin-face)    ;; '=' is an operator
    ("\\[.*\\]" . font-lock-string-face) ;; strings
    ("<[xa-fA-F0-9]+>" . 'font-lock-variable-name-face))
  '("\\.\\(asli?\\|asl\\)$")           ;; files for which to activate this mode
  '((lambda ()))   ;; other functions to call
  "A mode for ACPI files"
  )

;;; asl-mode.el ends here
