" Syntax highlighting for regex patterns
" Used in Regex Mastery exercises

if exists("b:current_syntax")
  finish
endif

" Metacharacters
syntax match regexSpecial /[.^$|*+?{}()\[\]\\]/

" Character classes
syntax match regexCharClass /\[\^*[^\]]*\]/
syntax match regexCharClass /\[[^\]]*\]/

" Shorthands
syntax match regexShorthand /\\[dDwWsS]/
syntax match regexShorthand /\\b\|\\B/

" Quantifiers
syntax match regexQuantifier /[*+?]/
syntax match regexQuantifier /{[0-9,]\+}/

" Anchors
syntax match regexAnchor /[\^$]/
syntax match regexAnchor /\\[bB]/

" Escaped characters
syntax match regexEscape /\\./

" Groups
syntax match regexGroup /([^)]*)/

" Alternation
syntax match regexAlternation /|/

" Literals (fallback - normal text)
syntax match regexLiteral /[a-zA-Z0-9]/

" Define highlight groups
highlight default link regexSpecial Special
highlight default link regexCharClass Type
highlight default link regexShorthand Function
highlight default link regexQuantifier Number
highlight default link regexAnchor Keyword
highlight default link regexEscape SpecialChar
highlight default link regexGroup Identifier
highlight default link regexAlternation Operator
highlight default link regexLiteral Normal

" Additional custom colors for better visibility
highlight regexCharClass guifg=#E5C07B gui=bold ctermfg=180 cterm=bold
highlight regexQuantifier guifg=#D19A66 gui=bold ctermfg=173 cterm=bold
highlight regexAnchor guifg=#C678DD gui=bold ctermfg=176 cterm=bold
highlight regexShorthand guifg=#61AFEF gui=bold ctermfg=75 cterm=bold
highlight regexGroup guifg=#98C379 ctermfg=114
highlight regexAlternation guifg=#E06C75 gui=bold ctermfg=204 cterm=bold

let b:current_syntax = "regex"
