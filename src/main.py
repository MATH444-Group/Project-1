import logging
import pandas as pd
import sys

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