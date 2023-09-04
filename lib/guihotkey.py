#! /usr/bin/env python
# -*- coding: utf-8 -*-
#======================================================================
#
# guihotkey.py - 
#
# Created by skywind on 2023/09/04
# Last Modified: 2023/09/04 14:18:45
#
#======================================================================
from __future__ import print_function, unicode_literals
import sys
import os
import time


#----------------------------------------------------------------------
# extracted from winuser.h
#----------------------------------------------------------------------
KEY_DEFINITION = {
    'LBUTTON': 1,
    'RBUTTON': 2,
    'CANCEL': 3,
    'MBUTTON': 4,
    'XBUTTON1': 5,
    'XBUTTON2': 6,
    'BACK': 8,
    'TAB': 9,
    'CLEAR': 12,
    'RETURN': 13,
    'SHIFT': 16,
    'CONTROL': 17,
    'MENU': 18,
    'PAUSE': 19,
    'CAPITAL': 20,
    'KANA': 0x15,
    'HANGEUL': 0x15,
    'HANGUL': 0x15,
    'JUNJA': 0x17,
    'FINAL': 0x18,
    'HANJA': 0x19,
    'KANJI': 0x19,
    'ESCAPE': 0x1B,
    'CONVERT': 0x1C,
    'NONCONVERT': 0x1D,
    'ACCEPT': 0x1E,
    'MODECHANGE': 0x1F,
    'SPACE': 32,
    'PRIOR': 33,
    'NEXT': 34,
    'END': 35,
    'HOME': 36,
    'LEFT': 37,
    'UP': 38,
    'RIGHT': 39,
    'DOWN': 40,
    'SELECT': 41,
    'PRINT': 42,
    'EXECUTE': 43,
    'SNAPSHOT': 44,
    'INSERT': 45,
    'DELETE': 46,
    'HELP': 47,
    'LWIN': 0x5B,
    'RWIN': 0x5C,
    'APPS': 0x5D,
    'SLEEP': 0x5F,
    'NUMPAD0': 0x60,
    'NUMPAD1': 0x61,
    'NUMPAD2': 0x62,
    'NUMPAD3': 0x63,
    'NUMPAD4': 0x64,
    'NUMPAD5': 0x65,
    'NUMPAD6': 0x66,
    'NUMPAD7': 0x67,
    'NUMPAD8': 0x68,
    'NUMPAD9': 0x69,
    'MULTIPLY': 0x6A,
    'ADD': 0x6B,
    'SEPARATOR': 0x6C,
    'SUBTRACT': 0x6D,
    'DECIMAL': 0x6E,
    'DIVIDE': 0x6F,
    'F1': 0x70,
    'F2': 0x71,
    'F3': 0x72,
    'F4': 0x73,
    'F5': 0x74,
    'F6': 0x75,
    'F7': 0x76,
    'F8': 0x77,
    'F9': 0x78,
    'F10': 0x79,
    'F11': 0x7A,
    'F12': 0x7B,
    'F13': 0x7C,
    'F14': 0x7D,
    'F15': 0x7E,
    'F16': 0x7F,
    'F17': 0x80,
    'F18': 0x81,
    'F19': 0x82,
    'F20': 0x83,
    'F21': 0x84,
    'F22': 0x85,
    'F23': 0x86,
    'F24': 0x87,
    'NUMLOCK': 0x90,
    'SCROLL': 0x91,
    'LSHIFT': 0xA0,
    'RSHIFT': 0xA1,
    'LCONTROL': 0xA2,
    'RCONTROL': 0xA3,
    'LMENU': 0xA4,
    'RMENU': 0xA5,
    'BROWSER_BACK': 0xA6,
    'BROWSER_FORWARD': 0xA7,
    'BROWSER_REFRESH': 0xA8,
    'BROWSER_STOP': 0xA9,
    'BROWSER_SEARCH': 0xAA,
    'BROWSER_FAVORITES': 0xAB,
    'BROWSER_HOME': 0xAC,
    'VOLUME_MUTE': 0xAD,
    'VOLUME_DOWN': 0xAE,
    'VOLUME_UP': 0xAF,
    'MEDIA_NEXT_TRACK': 0xB0,
    'MEDIA_PREV_TRACK': 0xB1,
    'MEDIA_STOP': 0xB2,
    'MEDIA_PLAY_PAUSE': 0xB3,
    'LAUNCH_MAIL': 0xB4,
    'LAUNCH_MEDIA_SELECT': 0xB5,
    'LAUNCH_APP1': 0xB6,
    'LAUNCH_APP2': 0xB7,
    'OEM_1': 0xBA,
    'OEM_PLUS': 0xBB,
    'OEM_COMMA': 0xBC,
    'OEM_MINUS': 0xBD,
    'OEM_PERIOD': 0xBE,
    'OEM_2': 0xBF,
    'OEM_3': 0xC0,
    'OEM_4': 0xDB,
    'OEM_5': 0xDC,
    'OEM_6': 0xDD,
    'OEM_7': 0xDE,
    'OEM_8': 0xDF,
    'OEM_102': 0xE2,
    'PROCESSKEY': 0xE5,
    'PACKET': 0xE7,
    'ATTN': 0xF6,
    'CRSEL': 0xF7,
    'EXSEL': 0xF8,
    'EREOF': 0xF9,
    'PLAY': 0xFA,
    'ZOOM': 0xFB,
    'NONAME': 0xFC,
    'PA1': 0xFD,
    'OEM_CLEAR': 0xFE,
}


#----------------------------------------------------------------------
# ALIASES
#----------------------------------------------------------------------
KEY_ALIASES = {
    'ENTER': 'RETURN',
    'CR': 'RETURN',
    'ESC': 'ESCAPE',
    'BACKSPACE': 'BACK',
    'BS': 'BACK',
    'DEL': 'DELETE',
    'CTRL': 'CONTROL',
    'LCTRL': 'LCONTROL',
    'RCTRL': 'RCONTROL',
}


#----------------------------------------------------------------------
# platform
#----------------------------------------------------------------------
class Platform (object):

    def __init__ (self):
        self._GetAsyncKeyState = None

    def KeyState (self, keycode):
        if self._GetAsyncKeyState is None:
            self.__setup_ctypes()
        if isinstance(keycode, str):
            if keycode in KEY_DEFINITION:
                code = KEY_DEFINITION[keycode]
            elif keycode in KEY_ALIASES:
                name = KEY_ALIASES[keycode]
                code = KEY_DEFINITION[name]
            elif len(keycode) == 1:
                code = ord(keycode)
            else:
                raise KeyError('invalid key: %s'%keycode)
        else:
            code = keycode
        if self._GetAsyncKeyState:
            hr = self._GetAsyncKeyState(code)
            return (hr < 0) and True or False
        return False

    def KeySequence (self, keys):
        keys = keys.strip().split('+')
        for key in keys:
            key = key.strip()
            if key == '':
                continue
            if not self.KeyState(key):
                return False
        return True

    def __setup_ctypes (self):
        import ctypes
        self._user32 = ctypes.windll.LoadLibrary('user32.dll')
        GetAsyncKeyState = self._user32.GetAsyncKeyState
        GetAsyncKeyState.argtypes = [ ctypes.c_int ]
        GetAsyncKeyState.restype = ctypes.c_short
        self._GetAsyncKeyState = GetAsyncKeyState
        return 0

    # load content
    def load_file_content (self, filename, mode = 'r'):
        if hasattr(filename, 'read'):
            try: content = filename.read()
            except: pass
            return content
        try:
            fp = open(filename, mode)
            content = fp.read()
            fp.close()
        except:
            content = None
        return content

    # load file and guess encoding
    def load_file_text (self, filename, encoding = None):
        content = self.load_file_content(filename, 'rb')
        if content is None:
            return None
        if content[:3] == b'\xef\xbb\xbf':
            text = content[3:].decode('utf-8')
        elif encoding is not None:
            text = content.decode(encoding, 'ignore')
        else:
            text = None
            guess = [sys.getdefaultencoding(), 'utf-8']
            if sys.stdout and sys.stdout.encoding:
                guess.append(sys.stdout.encoding)
            try:
                import locale
                guess.append(locale.getpreferredencoding())
            except:
                pass
            visit = {}
            for name in guess + ['gbk', 'ascii', 'latin1']:
                if name in visit:
                    continue
                visit[name] = 1
                try:
                    text = content.decode(name)
                    break
                except:
                    pass
            if text is None:
                text = content.decode('utf-8', 'ignore')
        return text

    # load ini without ConfigParser
    def load_ini (self, filename, encoding = None):
        text = self.load_file_text(filename, encoding)
        config = {}
        sect = 'default'
        if text is None:
            return None
        for line in text.split('\n'):
            line = line.strip('\r\n\t ')
            if not line:
                continue
            elif line[:1] in ('#', ';'):
                continue
            elif line.startswith('['):
                if line.endswith(']'):
                    sect = line[1:-1].strip('\r\n\t ')
                    if sect not in config:
                        config[sect] = {}
            else:
                pos = line.find('=')
                if pos >= 0:
                    key = line[:pos].rstrip('\r\n\t ')
                    val = line[pos + 1:].lstrip('\r\n\t ')
                    if sect not in config:
                        config[sect] = {}
                    config[sect][key] = val
        return config


#----------------------------------------------------------------------
# logs
#----------------------------------------------------------------------
LOGFILE = None
LOGSTDOUT = True

def mlog(*args):
    global LOGFILE, LOGSTDOUT
    text = ' '.join(args)
    now = time.strftime('%Y-%m-%d %H:%M:%S')
    txt = '[%s] %s'%(now, text)
    if LOGFILE:
        LOGFILE.write(txt + '\n')
        LOGFILE.flush()
    if LOGSTDOUT:
        sys.stdout.write(txt + '\n')
        sys.stdout.flush()
    return 0


#----------------------------------------------------------------------
# Configure
#----------------------------------------------------------------------
class Configure (object):
    
    def __init__ (self, ininame):
        self.platform = Platform()
        self.tasks = {}
        self.state = {}
        self.filetime = 0
        self.ininame = os.path.abspath(ininame)
        self.load_config()

    def load_config (self):
        if not os.path.exists(self.ininame):
            raise IOError('bad file name: ' + self.ininame)
        self.tasks = self.platform.load_ini(self.ininame)
        self.state = {}
        self.filetime = os.stat(self.ininame).st_mtime
        mlog('load %d keymaps from: %s'%(len(self.tasks), self.ininame))
        return 0

    def key_detect (self):
        for name in self.tasks:
            key = name.strip()
            if key == '':
                continue
            if key == 'default':
                continue
            state = self.platform.KeySequence(key)
            if state:
                if not self.state.get(key, False):
                    self.state[key] = True
                    self._trigger_event(name)
            else:
                if self.state.get(key, False):
                    self.state[key] = False
        return 0

    def _trigger_event (self, name):
        task = self.tasks[name]
        mlog('event:', name)


#----------------------------------------------------------------------
# testing suit
#----------------------------------------------------------------------
if __name__ == '__main__':
    def test1():
        plat = Platform()
        while 1:
            time.sleep(0.1)
            print(plat.KeySequence('CTRL+ENTER'))
        return 0
    test1()



