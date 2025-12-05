import logging
import os
import pandas as pd
import sys
import time





import __init__

import data_loader as dl





def main():

  __FILE_PATH__ = '../data/train.csv'
  
  df = dl.load_df(__FILE_PATH__)

  print(df.head())



if __name__ == '__main__':

  main()