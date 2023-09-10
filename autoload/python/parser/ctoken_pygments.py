#! /usr/bin/env python
# -*- coding: utf-8 -*-
#======================================================================
#
# ctoken_pygments.py - 
#
# Created by skywind on 2022/12/27
# Last Modified: 2022/12/27 18:07:46
#
#======================================================================
import pygments
import pygments.token
import pygments.lexers

from pygments.token import Token

try:
    from . import ctoken
    from . import ctoken_reader
    from . import ctoken_type
    from .ctoken_type import *
except:
    import ctoken
    import ctoken_reader
    import ctoken_type
    from ctoken_type import *



#----------------------------------------------------------------------
# ignore token type
#----------------------------------------------------------------------
_ignore_types = [
            Token.Text.Whitespace,
            Token.Comment.Multiline,
            Token.Comment.Single,
            Token.Comment.count
        ]


#----------------------------------------------------------------------
# translate type
#----------------------------------------------------------------------
_translate_types = {
            # Token.
            Token.Keyword: CTOKEN_KEYWORD,

        }


#----------------------------------------------------------------------
# get pygments tokens
#----------------------------------------------------------------------
def _pygments_get_tokens(source, lang = 'cpp'):
    import pygments
    import pygments.lexers
    lexer = pygments.lexers.get_lexer_by_name(lang)
    if isinstance(source, str):
        code = source
    else:
        code = source.read()
    tokens = []
    for token in lexer.get_tokens(code):
        tokens.append(token)
    return tokens


#----------------------------------------------------------------------
# pygments_tokens -> ctoken list
#----------------------------------------------------------------------
def translate(pygments_tokens):
    tokens = []
    reader = ctoken_reader.TokenReader(pygments_tokens)
    while not reader.is_eof():
        if reader.current is None:
            break
        if reader.current[0] in Token.String:
            text = ''
            while reader.current[0] in Token.String:
                text += reader.current[1]
                reader.advance(1)
            token = ctoken.Token(CTOKEN_STRING, text, None, None)
            tokens.append(token)
        elif reader.current[0] in Token.Keyword:
            token = ctoken.Token(CTOKEN_KEYWORD, reader.current[1], None, None)
            tokens.append(token)
        elif reader.current[0]: 
            pass
    return tokens


#----------------------------------------------------------------------
# testing suit
#----------------------------------------------------------------------
if __name__ == '__main__':
    def test1():
        f = 'e:/lab/workshop/language/test_tok.c'
        tokens = _pygments_get_tokens(open(f), 'cpp')
        for t in tokens:
            print(t)
            # print(dir(t))
        return 0
    test1()

