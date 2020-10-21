import os
import shutil


# Environment Variables
$AUTO_CD = True
$AUTO_PUSHD = True
$COMPLETION_IN_THREAD = True
# $ENABLE_ASYNC_PROMPT = True  # これを on にするとバグる
$XONSH_CACHE_EVERYTHING = True
$XONSH_HISTORY_MATCH_ANYWHERE = True
$XONSH_SHOW_TRACEBACK = True

# PROMPT
def _git_user_name():
    """Git の user name を表示"""
    if os.path.isdir(".git"):
        return $(git config user.name).rstrip()
    else:
        return None

$PROMPT_FIELDS['git_user_name'] = _git_user_name
$PROMPT = '{GREEN}{user}@{hostname} {BLUE}{cwd} {GREEN}{git_user_name:[{}]} {RESET}{gitstatus}\n{RESET}{prompt_end}>> '


# Source .shell_common
source-bash ~/.shell_common

# PATH
def _path_inserter(p):
    if os.path.isdir(p):
        $PATH.insert(0, p)

_path_inserter('/usr/local/bin')


# Aliases
aliases['ll'] = 'ls -l'
aliases['la'] = 'ls -la'
if shutil.which('gtime'):
    aliases['time'] = 'gtime'
if shutil.which('gxargs'):
    aliases['xargs'] = 'gxargs'
