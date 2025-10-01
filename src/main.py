import logging
import os
import pandas as pd
import sys

if not os.path.isdir('utils'):
  os.system('git clone https://github.com/GevChalikyan/utils.git')
else:
  os.system('''cd utils
    git pull
    cd ..''')

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