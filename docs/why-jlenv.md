# Why jlenv?

[Return Home>](/jlenv/)

## Page of Contents

* [Why jlenv?](#why-jlenv)
  * [jlenv does…_](#jlenv-does_)
  * [Jlenv <em>does not…</em>](#jlenv-does-not)
  
## jlenv _does…_

* Support specifying **application-specific Julia versions** with
  `.julia-version` file.
* Let you **change the global Julia version** on a per-user basis.
* Allow you to **override the Julia version** with an environment variable.

## Jlenv _does not…_

* **Need to be loaded into your shell.** Instead, jlenv's shim approach works
  by adding a directory to your `$PATH`.
* **Override shell commands like `cd` or require prompt hacks.** That's
  dangerous and error-prone.
* **Have a configuration file.** There's nothing to configure except which
  version of Julia you want to use.
* **Install Julia.** You can build and install Julia yourself, or use 
  [julia-build](https://github.com/jlenv/julia-build) to automate the process.
* **Manage Packages.** [Pkg](https://julialang.github.io/Pkg.jl/stable/managing-packages/) 
  is a better way to manage application dependencies. 
* **Require changes to Julia libraries for compatibility.** The simplicity of 
  jlenv means as long as it's in your `$PATH`, 
  [nothing](https://discourse.julialang.org/t/handling-multiple-versions-of-julia/14035)
  [else](http://modules.sourceforge.net/) needs to know about it.
