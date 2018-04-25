(defparameter *simple-grammar*
  '((sentence -> (noun-phrase verb-phrase))
    (noun-phrase -> (Article Noun))
    (verb-phrase ->(Verb noun-phrase))
    (Article -> the a)
    (Noun -> man ball woman table)
    (Verb -> hit took saw liked))
  "A grammar for a trivial subset of English.")


(defvar *grammar* *simple-grammar*
  "The grammar used by generate. Initially,this is
  *simple-grammar*, but we can switch to other grammars.")


(defun rule-lhs (rule)
  "The left-hand side of a rule."
  (first rule))


(defun rule-rhs (rule)
  "The right-hand side of a rule."
  (rest (rest rule)))


(defun rewrites (category)
  "Return a list of the possible rewrites for this category."
  (rule-rhs (assoc category *grammar*)))


(defun mappend (fn the-list)
  "Apply fn to each element of list and append the results."
  (apply #'append (mapcar fn the-list)))

(defun random-elt (choices)
  "Choose an element from a list at random."
  (elt choices (random (length choices))))


(defun generate (phrase)
  "Generate a random sentence or phrase"
  (cond ((listp phrase)
	 (mappend #'generate phrase))
	((rewrites phrase)
	 (generate (random-elt (rewrites phrase))))
	(t (list phrase))))


(defun generate1 (phrase)
  (let ((choices (rewrites phrase)))
    (cond ((listp phrase)
	   (mappend #'generate1 phrase))
	  (choices (generate1 (random-elt choices)))
	  (t (list phrase)))))


(defun generate2 (phrase)
  (let ((choices (rewrites phrase)))
    (if (not choices)
	(list phrase)
	(if (listp (first choices))
	    (mappend #'generate2 (first choices))
	    (generate2 (random-elt choices))))))
