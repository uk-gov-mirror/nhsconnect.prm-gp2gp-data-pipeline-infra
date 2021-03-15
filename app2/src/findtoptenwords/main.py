import json
import logging
from os import environ

import boto3

from urllib.parse import urlparse
from findtoptenwords.config import FindTopTenWords

logger = logging.getLogger(__name__)



if __name__ == "__main__":
    main(config=FindTopTenWords.from_environment_variables(environ))