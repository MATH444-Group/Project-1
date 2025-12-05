import logging
import os
import pandas as pd
import sys
import time





import __init__

import data_loader as dl





def hasNull(df):

  numNullValues = df.isna().sum().sum()
  
  if numNullValues != 0:
    print(f'{numNullValues} null values found!')
    return True
  return False

def cleanData(df):

  if hasNull(df):

    # Drops attributes with more than 1/3 null values
    THRESHOLD: int = df.shape[0] - (df.shape[0] / 3)
    print(f'Dropping columns with less than {THRESHOLD} valid values...')
    INITIAL_COL = df.shape[1]

    df = df.dropna(axis=1, thresh=THRESHOLD)

    COL_DROPPED = INITIAL_COL - df.shape[1]
    print(f'Successfully dropped {COL_DROPPED} columns...')





    # Drops all rows with ANY null values
    print('Dropping any remaining rows with null values...')
    INITIAL_ROWS = df.shape[0]
    print(f'Initial # of Rows: {INITIAL_ROWS}')

    df = df.dropna(axis=0)

    ROWS_DROPPED = INITIAL_ROWS - df.shape[0]
    print(f'Successfully dropped {ROWS_DROPPED} rows...')

  return df






def main():
  
  FILE_PATH = '../data/train.csv'


  
  df = dl.load_df(FILE_PATH)

  df = cleanData(df)

  print(df.head())
  print(df.shape[0])



if __name__ == '__main__':

  main()