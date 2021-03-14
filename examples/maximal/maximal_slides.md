<#include meta/slides.md>

Maximal Slides
==============


Columns
-------

\colBegin{0.5}

Java

* kompiliert zu *Bytecode*
* *Multipass* Compiler
* *Optimierungen* zur Runtime
* *Linking* zur Runtime

\colNext{0.5}

C/C++

* kompiliert zu *Objectcode*
* *Onepass* Compiler Design (In Realität aber Multipass)
* *Optimierungen* zur *Compiletime*
* *Linking* zur Compile- oder Runtime

\colEnd


Image drawio
------------

![Image description](images/build_dependencies.pdf){height=75%}


Image direct
------------

![Image description](images/io-classes.png){height=75%}


Image tikz
----------

![Image description](images/down_cast.pdf){height=75%}


Links
-----

* Lorem

### Links

* [An Introduction to Modern CMake](https://cliutils.gitlab.io/modern-cmake/)
* [Effective Modern CMake](https://gist.github.com/mbinna/c61dbb39bca0e4fb7d1f73b0d66a4fd1)
* [C++Now 2017: Daniel Pfeifer - Effective CMake](https://www.youtube.com/watch?v=bsXLMQ6WgIk)


Inline code
-----------

~~~ {.cmake .numberLines}
cmake_minimum_required(VERSION 3.10)
project(example)

# collect sources
file(GLOB_RECURSE src src/*.cpp)

# main app target
add_executable(example_app ${src})
target_link_libraries(example_app
    PRIVATE pthread)

# define compile flags (warnings are fatal / add more checks)
set(cxxflags -Werror -Wall -Wextra -Wconversion -Wpedantic)

# set compiler flags
target_compile_options(example_app PRIVATE ${cxxflags})
~~~


Formulas
--------

Die Multiplikation zweier Matrizen $A$ und $B$, $R = A \times B$ ist wie folgt definiert:
$r_{i,j} = \sum_{k=1}^{v} a_{i,k}b_{k,j}$,
wobei $A$ eine $u \times v$, $B$ eine $v \times w$ und $R$ eine $u \times w$ Matrix sind.

Zum Beispiel: $\begin{pmatrix}
a_{0,0} & a_{0,1} & a_{0,2} \\
a_{1,0} & a_{1,1} & a_{1,2} \\
\end{pmatrix} \times \begin{pmatrix}
b_{0,0} \\
b_{1,0} \\
b_{2,0} \\
\end{pmatrix} = \begin{pmatrix}
a_{0,0} \times b_{0,0} + a_{0,1} \times b_{1,0} + a_{0,2} \times b_{2,0} \\
a_{1,0} \times b_{0,0} + a_{1,1} \times b_{1,0} + a_{1,2} \times b_{2,0} \\
\end{pmatrix} = \begin{pmatrix}
r_{0,0} \\
r_{1,0} \\
\end{pmatrix}$
