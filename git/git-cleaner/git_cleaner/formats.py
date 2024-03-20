#!/usr/bin/env python
# -*- coding: utf-8 -*-

fmt_config = '  {:25}: {}'
fmt_list_header = '| {:^70} | {:^60} |'
fmt_list_body = '| {:70} | {} | {:32} |'

fmt_notification_message = ("""
Dear {name},

You received this meessage because you are the last committer of outdated branch.
This branch should be removed or protected.

Information
  * Branch Name: {branch}
  * Branch URL: {url_branch}
  * Last commit date: {date}
  * Merged: {merged}

If you want to protect branch, please add it on Protected_branches wiki page of "{repo}"repository.
{url}

If you want to delete this branch run this console command:
git push origin --delete {branch}

If you want to tag this branch run this console commands (don't forget to stash your local changes):
git checkout {branch}
git tag <tagname>
git push origin --tags

Best regards, DevOps Team
""")

fmt_delete_message = ("""
Dear {name},

You received this meessage because you are the last committer of outdated branch.
This branch was removed due git cleanup process.

Information
  * Branch Name: {branch}
  * Branch URL: {url_branch}
  * Last commit date: {date}
  * Merged: {merged}

If you need this branch to be avaible on remote site you should push it back from your local git repository.

If you want to protect any branch, please add it on Protected_branches wiki page of "{repo}"repository.
{url}

Best regards, DevOps Team
""")
