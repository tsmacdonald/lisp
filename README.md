# Let's make a Lisp.

## Challenge 1
Evaluate numbers and Booleans:

```
lisp_eval("1").should == 1
lisp_eval("#t").should == true
```

## Challenge 2

Evaluate simple addition and multiplication function calls:

```
lisp_eval("(+ 1 2)").should == 3
lisp_eval("(* 2 2 3)").should == 12
```

## Challenge 3

Evaluate nested addition and multiplication calls

```
lisp_eval("(+ 1 (* 2 3))").should == 7
```

## Challenge 4

Evaluate conditionals:

```
lisp_eval("(if #t 1 2)").should == 1
lisp_eval("(if #f #t #f)").should == false
```


## Challenge 5

Evaluate top-level definitions:

```
lisp_eval("(def x 3)
           (+ x 1)").should == 4
```

## Challenge 6

Evaluate simple `let` bindings:

```
lisp_eval("(let (x 3)
             x)").should == 3
```

## Challenge 7

Evaluate more sophisticated `let` bindings:

```
lisp_eval("(let (x 3)
             (+ x 1))").should == 4
```

## Challenge 8

Evaluate `let` bindings with multiple variables:

```
lisp_eval("(let (x 3
                 y 4)
             (+ x y))").should == 7
```

## Challenge 9

Evaluate function definitions:

```
code = "(defn add2 (x)
          (+ x 2))

        (add2 9)"

lisp_eval(code).should == 1
```

## CHALLENGE 10
Evaluates function definitions with multiple variables:

```
code = "(defn maybeAdd2 (bool x)
          (if bool
            (+ x 2)
            x))

        (+ (maybeAdd2 1 #t) (maybeAdd2 1 #f))"

lisp_eval(code).should == 4
```
