import logging
import os
import pandas as pd
import sys
import time





import __init__

import dataHandler as dh





RAW_DATA_DIR: os.path = '../data/raw/'
RAW_DATA_FILE: os.path = 'train.csv'
RAW_DATA_PATH: os.path = os.path.join(RAW_DATA_DIR, RAW_DATA_FILE)

CLEAN_DATA_DIR: os.path = '../data/cleaned/'
CLEAN_DATA_FILE: os.path = 'cleaned train.csv'
CLEAN_DATA_PATH: os.path = os.path.join(CLEAN_DATA_DIR, CLEAN_DATA_FILE)





def main():
  
  df = dh.importData(RAW_DATA_PATH)

  df = dh.cleanData(df)

  dh.exportData(df, CLEAN_DATA_PATH)



if __name__ == '__main__':

  main()