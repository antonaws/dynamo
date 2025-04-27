import logging
import os
import sys
from logging.handlers import RotatingFileHandler

def get_logger(name):
    logger = logging.getLogger(name)
    if not logger.handlers:
        configure_dynamo_logger()
    return logger

def configure_server_logging():
    configure_dynamo_logger()  # Remove the arguments here

def configure_dynamo_logger():
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        handlers=[
            logging.StreamHandler(sys.stdout)
        ]
    )
