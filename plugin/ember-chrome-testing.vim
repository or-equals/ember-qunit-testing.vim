if !exists("*s:YankTestId")
  function s:GetTestName()
    let [_, x, y,_] = getpos('.') "get cursor position
    call cursor(x, 200) "move to 'end of line' in case we're on a test line at the first char position
    let test_line = search('test(', 'b')
    let [_, test_name_start_y] = searchpos("['\"]", 'n', line('.'))

    " grab the name of the test
    let test_line=getline('.')
    let test_string_delim = test_line[test_name_start_y-1]
    call cursor(test_line, test_name_start_y)
    let [_, test_name_end_y] = searchpos(test_string_delim, 'n', line('.'))
    let test_name_len = test_name_end_y - test_name_start_y - 1


    let test_name=strpart(test_line, test_name_start_y, test_name_len)

    " restore cursor
    call cursor(x,y)

    return test_name
  endfunction

  function s:YankTestId()
    let test_name=s:GetTestName()
    let module_name=s:GetModuleName()
    let base_url='http://localhost:4200/tests?nojshint=true&testId='

    let test_arg=shellescape(test_name)
    let module_arg=shellescape(module_name)
    let test_id=system("qunit-test-hash " . module_arg . " " . test_arg)
    let @+= base_url . test_id
  endfunction
endif

if !exists("*s:YankModuleName")
  function s:GetModuleName()
    let [_, x, y,_] = getpos('.') "get cursor position
    call cursor(x, 200) "move to 'end of line' in case we're on a test line at the first char position
    let module_line = search('^module', 'b')
    let [_, module_name_start_y] = searchpos("['\"]", 'n', line('.'))

    " grab the name of the test
    let module_line=getline('.')
    let module_string_delim = module_line[module_name_start_y-1]
    call cursor(module_line, module_name_start_y)
    let [_, module_name_end_y] = searchpos("['\"]", 'n', line('.'))
    let module_name_len = module_name_end_y - module_name_start_y - 1

    let module_name=strpart(module_line, module_name_start_y, module_name_len)

    if match(module_line, 'moduleForComponent') != -1
      let module_name='component:' . module_name
    endif

    " restore cursor
    call cursor(x,y)

    return module_name
  endfunction

  function s:YankModuleName()
    let base_url='http://localhost:4200/tests?nojshint=true&module='
    let @+= base_url . s:GetModuleName()
  endfunction
endif

nmap <leader>M :call <SID>YankTestId()<CR>
nmap <leader>m :call <SID>YankModuleName()<CR>
