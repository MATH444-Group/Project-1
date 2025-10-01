import logging
import pandas as pd

def load_df(file_path):

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
    logging.error(f'An unexpected error occurred:\n{e}')
    exit(1)

  return df