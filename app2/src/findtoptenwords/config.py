import logging
import sys
from dataclasses import MISSING, fields, dataclass
from typing import Optional

logger = logging.getLogger(__name__)


def _read_env(field, env_vars):
    env_var = field.name.upper()
    if env_var in env_vars:
        return env_vars[env_var]
    elif field.default != MISSING:
        return field.default
    else:
        logger.error(f"Expected environment variable {env_var} was not set, exiting...")
        sys.exit(1)


@dataclass
class FindTopTenWords:
    s3_input_url: str
    s3_output_url: str
    s3_endpoint_url: Optional[str] = None

    @classmethod
    def from_environment_variables(cls, env_vars):
        return cls(**{field.name: _read_env(field, env_vars) for field in fields(cls)})