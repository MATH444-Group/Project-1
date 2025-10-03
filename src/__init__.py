import os
import sys
import time





git_log_file = '../logs/git.log'
dir = os.path.dirname(git_log_file)

if not os.path.isdir(dir):
  os.mkdir(dir)

if not os.path.isdir('utils'):
  os.system(f'printf \'{time.asctime()}:\\n\' > {git_log_file} 2>&1')
  os.system(f'git clone https://github.com/GevChalikyan/utils.git >> {git_log_file} 2>&1')

else:
  os.chdir('utils')
  git_log_file = '../' + git_log_file
  
  os.system(f'printf \'\\n{time.asctime()}:\\n\' >> {git_log_file} 2>&1')
  os.system(f'git pull >> {git_log_file} 2>&1')
  os.chdir('..')


sys.path.append('utils')