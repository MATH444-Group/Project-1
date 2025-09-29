import logging
import pandas as pd

logger = logging.getLogger(__name__)
try:
  logging.basicConfig(
    filename='../logs/app.log', 
    level=logging.INFO, 
    format='%(asctime)s | %(levelname)s:\n\t%(message)s'
  )
except Exception as e:
  print(f'Logging setup failed: {e}')
  exit(1)





def main():

  file_path = '../data/train.csv'
  
  try:
    df = pd.read_csv(file_path)
    logger.info(f'Successfully read the file at \'{file_path}\'.')

  except FileNotFoundError:
    logger.exception(f'Error: The file at \'{file_path}\' was not found.')
    exit(1)
  
  except pd.errors.EmptyDataError:
    logger.exception(f'Error: The file at \'{file_path}\' is empty.')
    exit(1)
  
  except pd.errors.ParserError as e:
    logger.exception(f'Error: There was a parsing error while reading the file:\n\t{e}')
    exit(1)

  except Exception as e:
    logger.exception(f'An unexpected error occurred:\n\t{e}')
    exit(1)



if __name__ == '__main__':
  main()