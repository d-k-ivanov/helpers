=================
Git Cleaner
=================

Cleanup merged branches with notification to last committer.

Installation
------------

.. code-block:: bash

    # Normal install from PyPI
    sudo pip3 install --upgrade git-cleaner
    # From git
    sudo pip3 install --upgrade --no-cache git+https://github.com/keepbot/py-git-cleaner@master
    # Locally
    git clone https://github.com/keepbot/py-git-cleaner.git
    sudo pip3 install --upgrade --no-cache ./py-git-cleaner


Usage
-----

.. code-block:: bash

    git-cleaner COMMAND [OPTIONS]

    Commands:
      list-merged               Print list of merged branches with dates
      list-no-merged            Print list of not merged branches with dates
      notify-last-committer     Notify developers about outdated branches
      remove-outdated-branches  Delete outdated branches
      show-config               Print config entries

    Global options:
      -h, --help     Show this message and exit.
      -v, --version  Show the version and exit.

    Local options:
      -h, --help              Show this message and exit.
      --target TEXT           Name of merge branch
      --age INTEGER           Age of nearest branch
      --merged / --no-merged  Merged or not merged branches


Environment
-----------

Following variables should be set:

.. code-block:: bash

    GIT_PROVIDER=bitbucket.org
    GIT_USER=keepbot
    GIT_REPO_NAME=py-git-cleaner
    EMAIL_FROM=git-cleaner@example.com
    EMAIL_SMTP_SERVER=smtp.example.com
    EMAIL_SMTP_PORT=587
    EMAIL_USER=git-cleaner@example.com
    EMAIL_PASS=git-cleaner-password
    EMAIL_ERROR=git-cleaner-error@example.com
    OAUTH_CLIENT_ID=bitbucket-client-id
    OAUTH_CLIENT_SECRET=bitbucket-sercret-id
    OAUTH_URI_ACCESS_TOKEN=https://bitbucket.org/site/oauth2/access_token
    OAUTH_URI_AUTHORIZATION=https://bitbucket.org/site/oauth2/authorize
