" --- Cockroach ---
function! s:CockroachExec()
  exec "silent %!/Users/justin/go/src/github.com/justinj/cr-wb/cr-wb"
endfunction
command! -nargs=* CR call s:CockroachExec()

function! s:TestLogic(args)
  let output = tempname()
  exec "silent !make testlogic TESTFLAGS=\"\" FILES=\"".a:args."\" \| tee ".output
  if match(readfile(output),"^FAIL$") >= 0
    exec "vsplit ".output
    setlocal nowrap
    setlocal nomodifiable
  endif
endfunction
command! -nargs=* TestLogic call s:TestLogic("<args>")
command! -nargs=* TL call s:TestLogic("<args>")

function! s:TestLogicRewrite(args)
  let output = tempname()
  exec "silent !make testlogic TESTFLAGS=\"-rewrite-results-in-testfiles\" FILES=\"".a:args."\" \| tee ".output
  if match(readfile(output),"^FAIL$") >= 0
    exec "vsplit ".output
    setlocal nowrap
    setlocal nomodifiable
  endif
endfunction
command! -nargs=* TLR call s:TestLogicRewrite("<args>")

" If you need more, add'em
let s:packages = {
      \ 'parser': 'pkg/sql/parser',
      \ 'tree': 'pkg/sql/sem/tree',
      \ 'json': 'pkg/util/json',
      \ 'treet': 'pkg/sql/sem/tree_test',
      \ 'cli': 'pkg/cli',
      \ 'sqlbase': 'pkg/sql/sqlbase',
      \ 'pgwire': 'pkg/sql/pgwire',
      \ 'xform': 'pkg/sql/opt/xform',
      \ 'opt': 'pkg/sql/opt',
      \}

function! s:CRTest(pkg, ...)
  let pkgname = s:packages[a:pkg]
  let test = (a:0 >= 1) ? a:1 : "."
  exec "silent !make test PKG=./".pkgname." TESTS=".test
endfunction
command! -nargs=* Test call s:CRTest(<f-args>)
command! -nargs=* T call s:CRTest(<f-args>)

function! s:CRBench(pkg, ...)
  let pkgname = s:packages[a:pkg]
  let test = (a:0 >= 1) ? a:1 : "."
  exec "silent !make bench PKG=./".pkgname." BENCHES=".test
endfunction
command! -nargs=* Bench call s:CRBench(<f-args>)
command! -nargs=* B call s:CRBench(<f-args>)

