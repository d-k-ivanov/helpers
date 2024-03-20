#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re

from git_cleaner.config import CONFIG


def is_remote(branch):
    if branch.startswith('remotes/origin') and 'origin/master' not in branch and 'origin/HEAD' not in branch:
        return True
    else:
        return False


def is_protected(branch):
    for pb in CONFIG['protected_branches']:
        r = re.compile(pb, re.IGNORECASE)
        if r.search(branch[15:]):
            return True
    return False
