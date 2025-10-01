import logging
import pandas as pd

try:
  logging.basicConfig(
    filename='../logs/app.log', 
    level=logging.INFO, 
    filemode='w',
    format='%(asctime)s | %(levelname)s:\n\t%(message)s'
  )
except Exception as e:
  print(f'Logging setup failed: {e}')
  exit(1)





def main():

  file_path = '../data/train.csv'
  
  try:
    df = pd.read_csv(file_path)
    logging.info(f'Successfully read the file at \'{file_path}\'.')

  except FileNotFoundError:
    logging.error(f'The file at \'{file_path}\' was not found.')
    exit(1)
  
  except pd.errors.EmptyDataError:
    logging.warning(f'The file at \'{file_path}\' is empty.')
  
  except pd.errors.ParserError as e:
    logging.error(f'There was a parsing error while reading the file:\n\t{e}')
    exit(1)

  except Exception as e:
    logging.error(f'An unexpected error occurred:\n\t{e}')
    exit(1)



if __name__ == '__main__':
  main()