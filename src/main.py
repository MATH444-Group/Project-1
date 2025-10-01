import logging
import os
import pandas as pd
import sys
import time

if not os.path.isdir('utils'):
  os.system('git clone https://github.com/GevChalikyan/utils.git')
else:
  
  git_log_file_relative_to_utils = '../../logs/git.log'
  git_log_dir_relative_to_utils = '../../logs'

  if not os.path.isdir(git_log_dir_relative_to_utils):
    os.mkdir(git_log_dir_relative_to_utils)

  os.chdir('utils')
  os.system(f'printf \'{time.asctime()}:\\n\' >> {git_log_file_relative_to_utils} 2>&1')
  os.system(f'git pull >> {git_log_file_relative_to_utils} 2>&1')
  os.chdir('..')

sys.path.append('utils')
import data_loader as dl





def main():

  file_path = '../data/train.csv'
  
  df = dl.load_df(file_path)

  print(df.head)



if __name__ == '__main__':

  import logger
  logger.setup()

  main()