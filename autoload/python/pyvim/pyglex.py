#! /usr/bin/env python
# -*- coding: utf-8 -*-
#======================================================================
#
# pyglex.py - 
#
# Created by skywind on 2023/09/11
# Last Modified: 2023/09/11 00:27:50
#
#======================================================================
import sys

try:
    from . import buffer
except:
    import buffer

from parser import ctoken_pygments


#----------------------------------------------------------------------
# buffer tokens
#----------------------------------------------------------------------
__buffer_tokens = {}


#----------------------------------------------------------------------
# vim ft to pygments langname
#----------------------------------------------------------------------
def get_language(filetype):
    return filetype


#----------------------------------------------------------------------
# get_tokens
#----------------------------------------------------------------------
def get_tokens(bid: int) -> list:
    tick = buffer.changedtick(bid)
    if tick < 0:
        return None
    if bid in __buffer_tokens:
        item = __buffer_tokens[bid]
        if tick == item[0]:
            return item[1]
    text = buffer.get_text(bid)
    lang = get_language(buffer.filetype(bid))
    tokens = ctoken_pygments.pygments_get_tokens(text, lang)
    __buffer_tokens[bid] = (tick, tokens)
    return tokens


#----------------------------------------------------------------------
# locate token
#----------------------------------------------------------------------
def locate_token(bid, lnum, column) -> int:
    tokens = get_tokens(bid)
    if tokens is None:
        return -1
    index: int = ctoken_pygments.token_locate(tokens, lnum, column)
    return index


