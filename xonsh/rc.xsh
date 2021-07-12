import os

def insert_path_if_exists(fpath):
    if not os.path.exists(fpath):
        return
    $PATH.insert(0, fpath)


insert_path_if_exists("/usr/local/bin")


$PROMPT = "{BOLD_WHITE}{user}@{hostname}{RESET}: {BLUE}{cwd}{RESET} {gitstatus}\n{env_name}{prompt_end}>> "
