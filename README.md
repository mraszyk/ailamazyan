# Reduction of a relational model with infinite domains to the case of finite domains

This artifact contains a formalization of the paper by Ailamazyan et al. [1]
and a formally verified executable implementation of the algorithm based on [1]
for evaluating arbitrary relational calculus (RC) queries.

## Abstract

We formalize first-order query evaluation over an infinite domain with equality.
We first define the syntax and semantics of first-order logic with equality.
Next we define a locale `eval_fo` abstracting a representation of
a potentially infinite set of tuples satisfying a first-order query
over finite relations.
Inside the locale, we define a function `eval` checking
if the set of tuples satisfying a first-order query over a database
(an interpretation of the query's predicates) is finite
(i.e., deciding *relative safety*)
and computing the set of satisfying tuples if it is finite.
Altogether the function `eval` solves *capturability* [2]
of first-order logic with equality.
We also use the function `eval` to prove a code equation
for the semantics of first-order logic, i.e.,
the function checking if a first-order query over a database
is satisfied by a variable assignment.

We provide an interpretation of the locale `eval_fo`
based on the approach by Ailamazyan et al. [1].
A core notion in the interpretation is the active domain of a query and
a database, where the active domain contains all domain elements occurring in the query and the database.
Our interpretation yields an *executable* function `eval`.
Finally, we export code for the infinite domain of natural numbers.

As future work, we aim at making the time complexity of `eval` on a query linear
in the number of rows in the finite relations representing
potentially infinite relations satisfying the subqueries of the query.
We remark that this is nontrivial to achieve for conjunctions.

## References

[1] A. K. Ailamazyan, M. M. Gilula, A. P. Stolboushkin, and G. F. Schwartz. Reduction of a
relational model with infinite domains to the case of finite domains.
Dokl. Akad. Nauk SSSR, 286:308--311, 1986.

[2] A. Avron and Y. Hirshfeld. On first order database query languages.
LICS '91, pp. 226--231. IEEE, 1991.

## Directory Structure

`html/` contains the formalization of the paper in Isabelle exported to html (open `html/index.html` in your favourite web browser).

`src/` contains the formally verified core (`verified.ml`) and unverified code to parse a query and a database.

`thys/` contains the formalization of the paper in Isabelle (open a theory source file in Isabelle/jEdit).

`paper.pdf` is the original paper by Ailamazyan et al. (in Russian).

## Formalization in Isabelle

The Isabelle sources are included in a separate directory called `thys`.
The theories can be studied by opening them in Isabelle/jEdit.

The formalization can been processed with the development version of Isabelle, which can be downloaded from

https://isabelle-dev.sketis.net/source/isabelle/

and installed following the standard instructions from

https://isabelle-dev.sketis.net/source/isabelle/browse/default/README_REPOSITORY

It also requires the development version of the Archive of Formal Proofs, which can be downloaded from

https://isabelle-dev.sketis.net/source/afp-devel/

and installed following the standard instructions from

https://www.isa-afp.org/using.html

To build the theories, export the verified OCaml code, and regenerate the HTML page, run
`isabelle build -o browser_info -c -e -v -D thys`
in the root directory of this artifact.
Instructions where to find the verified OCaml code and the generated html sources are printed in the console.

## Build

We recommend running the experiments using `docker` and the provided `Dockerfile`.
Note that the first command below will take a few minutes to finish.
```
sudo docker build --no-cache -t ail .
sudo docker run -it ail
```
Once you run the second command above you will
obtain a shell with all the tools installed.

## Usage

To run the verified code, execute
```
$ ./src/ail.native -fmla examples/ex1.fo -db examples/ex1.db
Finite
(x0)
(1)
$ ./src/ail.native -fmla examples/ex2.fo -db examples/ex2.db
Finite
(x0)
(0)
(1)
$ ./src/ail.native -fmla examples/ex2.fo -db examples/ex1.db
Finite
(x0,x1)
(1,100)
$ ./src/ail.native -fmla examples/ex2.fo -db examples/ex2.db
Infinite
```
The first line of the output says if the evaluation result is finite.
The second line of the output lists all free variables in the query.
The remaining lines of the output list all satisfying tuples.

**Remark.** All variable names must have the form `x{NUM}`
where `{NUM}` is a nonnegative integer.

RC Syntax

```
{f} ::=   TRUE
        | FALSE
        | {ID}({s})
        | {t} = {t}
        | NOT {f}
        | {f} AND {f}
        | {f} OR  {f}
        | EXISTS {VAR} . {f}
        | FORALL {VAR} . {f}

{t} ::=   {NUM}
        | {VAR}

{s} ::=   %empty
        | {t}
        | {t} , {s}
```

where `{NUM}` is a nonnegative integer (constant),
`{ID}` is an alphanumeric identifier starting with a letter,
and `{VAR}` is a variable identifier of the form `x{NUM}`.
Non-terminals are enclosed in curly braces.

Database Syntax

```
{d} :=   %empty
       | {ID}({s})
       | {ID}({s}) {d}

{s} ::=   %empty
        | {NUM}
        | {NUM} , {s}
```

where `{NUM}` is a nonnegative integer and `{ID}` is an identifier.
