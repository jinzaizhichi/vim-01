#! /usr/bin/env python
# -*- coding: utf-8 -*-
#======================================================================
#
# treesitter.py - 
#
# Created by skywind on 2023/09/10
# Last Modified: 2023/09/10 02:08:29
#
#======================================================================
from __future__ import print_function, unicode_literals
import sys
import time
import os
import tree_sitter



#----------------------------------------------------------------------
# internal
#----------------------------------------------------------------------
has_win32 = (sys.platform[:3] == 'win') and True or False
has_unix = (not has_win32)


#----------------------------------------------------------------------
# configure
#----------------------------------------------------------------------
class Configure (object):

    def __init__ (self):
        self.win32 = (sys.platform[:3] == 'win') and True or False
        self.has64 = (sys.maxsize > 2 ** 32) and True or False
        self.HOME = os.path.expanduser('~')
        self.__init_std_path()
        self.tslib = self.__search_parser_home()
        self.found = (self.tslib != '') and True or False
        self.__lang_cache = {}
        self.__parser_cache = {}
        self.error = ''

    def __init_std_path (self):
        t1 = os.path.normpath(self.HOME + '/.config')
        self.XDG_CONFIG_HOME = os.environ.get('XDG_CONFIG_HOME', t1)
        t2 = os.path.normpath(self.HOME + '/.local/share')
        self.XDG_DATA_HOME = os.environ.get('XDG_DATA_HOME', t2)
        t3 = os.path.normpath(self.HOME + '/.cache')
        self.XDG_CACHE_HOME = os.environ.get('XDG_CACHE_HOME', t3)
        self.APPDATA = self.XDG_DATA_HOME
        self.VIMHOME = os.path.normpath(self.HOME + '/.vim')
        self.NVIMDATA = os.path.join(self.XDG_DATA_HOME, 'nvim')
        if self.win32:
            t1 = os.path.join(self.XDG_DATA_HOME, 'Local')
            self.APPDATA = os.environ.get('APPDATA', t1)
            self.APPDATA = os.path.dirname(self.APPDATA)
            self.NVIMDATA = os.path.join(self.APPDATA, 'Local\\nvim-data')
        return 0

    def __search_parser_home (self):
        if self.win32:
            if not self.has64:
                t = os.path.join(self.VIMHOME, 'lib/parser')
            else:
                t = os.path.join(self.VIMHOME, 'lib/parser/64')
            if os.path.exists(t):
                return os.path.normpath(t)
            t = os.path.join(self.NVIMDATA, 'lazy/nvim-treesitter/parser')    
            if os.path.exists(t):
                return os.path.normpath(t)
        else:
            t1 = os.path.join(self.NVIMDATA, 'lazy/nvim-treesitter/parser')    
            t2 = os.path.join(self.VIMHOME, 'lib/parser')
            tries = [t1, t2]
            for t in tries:
                if os.path.exists(t):
                    return os.path.normpath(t)
        return ''

    def language (self, langname: str):
        if langname in self.__lang_cache:
            return self.__lang_cache[langname]
        if not self.tslib:
            raise RuntimeError('can not find treesitter parser home')
        t1 = os.path.join(self.tslib, langname + '.so')
        t2 = os.path.join(self.tslib, langname + '.dll')
        if self.win32 and os.path.exists(t2):
            lang = tree_sitter.Language(t2, langname)
        elif os.path.exists(t1):
            lang = tree_sitter.Language(t1, langname)
        else:
            raise RuntimeError('can not find parser dll for %s'%langname)
        self.__lang_cache[langname] = lang
        return lang

    def create_parser (self, langname: str):
        lang = self.language(langname)
        if not lang:
            raise RuntimeError('can not load dll for %s'%langname)
        parser = tree_sitter.Parser()
        parser.set_language(lang)
        return parser

    def parser (self, langname: str):
        if langname in self.__parser_cache:
            return self.__parser_cache[langname]
        parser = self.create_parser(langname)
        if parser:
            self.__parser_cache[langname] = parser
        return parser

    def check (self, langname: str):
        try:
            lang = self.language(langname)  # noqa
            parser = self.parser(langname)  # noqa
        except RuntimeError as e:
            self.error = str(e)
            return False
        return True
        
    def get_parser (self, langname: str):
        try:
            parser = self.parser(langname)
            return parser
        except RuntimeError:
            pass
        return None

    def parse (self, langname, source):
        parser = self.get_parser(langname)
        if parser is None:
            return None
        if isinstance(source, str):
            code = source.encode('utf-8', errors = 'ignore')
        elif isinstance(source, bytes):
            code = source
        else:
            return None
        return parser.parse(code)

    def query (self, langname, query):
        try:
            language = self.language(langname)
        except RuntimeError:
            return None
        return language.query(query)



#----------------------------------------------------------------------
# instance
#----------------------------------------------------------------------
config = Configure()


#----------------------------------------------------------------------
# test code
#----------------------------------------------------------------------
sample_python = '''
import sys
import os

class foo:
    def __init__ (self):
        print('foo')

def bar():
    print('bar')

if __name__ == '__main__':
    f = foo()
    bar()
'''

sample_c = '''
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    printf("Hello, World !!\n");
    return 0;
}
'''


#----------------------------------------------------------------------
# testing suit
#----------------------------------------------------------------------
if __name__ == '__main__':
    def test1():
        print(config.tslib)
        print(config.NVIMDATA)
        print(config.get_parser('c'))
        print(config.check('go'))
        print(config.check('go2'))
        return 0
    def test2():
        tree = config.parse('python', sample_python)
        print('tree', tree.root_node.sexp())
        print()
        tree = config.parse('c', sample_c)
        print('tree', tree.root_node.sexp())
    test2()




