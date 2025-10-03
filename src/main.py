import logging
import os
import pandas as pd
import sys
import time





import __init__

import data_loader as dl





def main():

  file_path = '../data/train.csv'
  
  df = dl.load_df(file_path)

  print(df.head())



if __name__ == '__main__':

  main()