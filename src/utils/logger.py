import logging
import os

def setup():
  try:
    log_dir = '../logs'
    log_file = '../logs/app.log'

    if not os.path.isfile(log_file):
      if not os.path.isdir(log_dir):
        os.mkdir(log_dir)
      with open(log_file, 'w') as f:
        pass

    logging.basicConfig(
      filename=log_file, 
      level=logging.INFO, 
      filemode='w',
      format='%(asctime)s | %(levelname)s:\n\t%(message)s'
    )

    logging.info('Successfully setup logger.')

  except Exception as e:
    print(f'Logging setup failed:\n{e}')
    exit(1)