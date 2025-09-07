# Tree Compiler-Compiler

The **treecc** program is designed to assist in the development of compilers
and other language-based tools. It manages the generation of code to handle
abstract syntax trees and operations upon the trees.

A fuller account of why **treecc** exists and what it can be used for can
be found in the Texinfo documentation within the [`doc`](doc) subdirectory,
and in the introductory article [`doc/essay.html`](doc/essay.html).

> **Note**  
> This distribution is a copy of the original **treecc** utility from
> the **DotGNU** project. Since that project no longer exists, it has
> become difficult to find **treecc** on the Internet, so I'm pushing a
> copy of the code here to **GitHub**.  
> The code is a little old and may need some help to get it to compile
> on modern systems.  
> Patches and pull requests are welcome — *Rhys Weatherley*.

---

## Building and Installing

TreeCC supports **two** build systems: the classic **autotools** and **CMake**.

### Option A: Using Autotools (classic)

Unpack the `.tar.gz` file into a temporary directory and run:

```bash
./configure
make all
make check
make install
````

`make check` runs the **treecc** test suite to check for any problems on your system.
Report any such problems to the authors, together with a script of the failed test output.

If you obtained the **treecc** sources via **Git** (from GitHub), you may need to run this
**before** `./configure`:

```bash
./auto_gen.sh
```

To install **treecc** somewhere other than the default prefix (`/usr/local`):

```bash
./configure --prefix=PREFIX
```

Where `PREFIX` is the full pathname of the directory where you want to install the program.

If you want to add a new output language, see [`doc/extending.txt`](doc/extending.txt).

---

### Option B: Using CMake (new)

TreeCC now supports **CMake** as an alternative build system alongside the traditional autotools setup.

#### Prerequisites

* CMake **3.10** or later
* C compiler (GCC, Clang, or compatible)
* Optional: `yacc`/`bison` and `lex`/`flex` for examples

#### Quick Start

```bash
# Configure with CMake
cmake -B build -S .

# Build
cmake --build build --parallel

# Run tests (scripted)
cd build/tests && srcdir=../../tests ../../tests/run_tests

# Or run tests using ctest
cd build && ctest

# Install (optional)
cmake --install build
```

#### Build Options

* `BUILD_CPP_EXAMPLE=ON` — Build the C++ example (requires a C++ compiler).

Example:

```bash
cmake -DBUILD_CPP_EXAMPLE=ON -B build -S .
```

#### Build Targets

* `treecc` — Main TreeCC compiler executable
* `treecc_static` — Static library containing TreeCC functionality
* `expr_c` — C expression evaluator example (if `yacc`/`lex` available)
* `test_input`, `test_parse`, `test_output`, `normalize` — Test programs

#### Installation

By default, CMake installs to:

* Binaries: `/usr/local/bin`
* Libraries: `/usr/local/lib`
* Headers: `/usr/local/include/treecc`
* Documentation: `/usr/local/share/doc/treecc`
* Examples: `/usr/local/share/doc/treecc/examples`

To change the installation prefix during configuration:

```bash
cmake -S . -B build -DCMAKE_INSTALL_PREFIX=/path/to/install
```

Then:

```bash
cmake --build build --parallel
cmake --install build
```

---

## Copyright Considerations

**Treecc** is distributed under the terms of the **GNU General Public License**.
A copy of this license can be found in the [`COPYING`](COPYING) file.

However, it is **not** our intention to restrict the use of **treecc** to only
free software providers. Use by commercial software vendors is welcome.

When you use **treecc** on your own input files to generate source code as
output, the resulting source code files are **owned by you**. You may
re-distribute unmodified copies of these output source files, and any
binaries derived from them, in any way you see fit.

If you modify **treecc** itself and generate new output files as a result,
then you **must** release all modifications to **treecc** with your program so
that other users can benefit from your changes under the terms of the GPL.

Contact the authors if you have any questions regarding the above.
It is our intention to allow the same amount of access to **treecc** output
files as is currently available using the **GNU Bison** and **Flex** programs.

---

## Contacting the Authors

Primary contacts:

* Rhys Weatherley — **[rhys.weatherley@gmail.com](mailto:rhys.weatherley@gmail.com)**
* Iván de Jesús Deras — **[ideras@gmail.com](mailto:ideras@gmail.com)**

> **Fork-specific support**
> For issues, questions, or patches **specific to this GitHub fork**, please contact **[ideras@gmail.com](mailto:ideras@gmail.com)**.
> Please **do not** contact Rhys about problems related to this fork.
