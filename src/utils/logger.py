import logging

def setup():
  try:
    logging.basicConfig(
      filename='../logs/app.log', 
      level=logging.INFO, 
      filemode='w',
      format='%(asctime)s | %(levelname)s:\n\t%(message)s'
    )

    logging.info('Successfully setup logger.')

  except Exception as e:
    print(f'Logging setup failed:\n{e}')
    exit(1)