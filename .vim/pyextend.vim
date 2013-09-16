function! GetHTML()
python << EOF
import vim, BeautifulSoup, urllib
handle = urllib.urlopen(vim.current.line)
soup = BeautifulSoup.BeautifulSoup(handle.read())
vim.current.buffer[:] = soup.prettify().split('\n')
EOF
endfunction

