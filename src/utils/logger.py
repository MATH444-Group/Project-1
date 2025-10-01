import logging
import os

def setup():
  try:
    log_dir = '../logs'
    log_file = '../logs/app.log'
    log_setup_info = {
      logging.WARNING: [],
      logging.INFO: []
    }



    if not os.path.isfile(log_file):
      log_setup_info[logging.WARNING].append('Log file missing')
      if not os.path.isdir(log_dir):
        log_setup_info[logging.WARNING].append('Log directory missing')
        os.mkdir(log_dir)
        log_setup_info[logging.INFO].append(f'Successfully created log directory at \'{log_dir}\'')

      with open(log_file, 'w') as f:
        log_setup_info[logging.INFO].append(f'Successfully created log file at \'{log_file}\'')



    logging.basicConfig(
      filename=log_file, 
      level=logging.INFO, 
      filemode='w',
      format='%(asctime)s | %(levelname)s:\n\t%(message)s'
    )

    

    for log_level in log_setup_info:
      for msg in log_setup_info[log_level]:
        logging.log(level=log_level, msg=msg)

    logging.info('Successfully setup logger.')

  except Exception as e:
    print(f'Logging setup failed:\n{e}')
    exit(1)