from pyshorteners import Shortener
import url_shortener.config as config
from logging import getLogger
import re

_LOGGER = getLogger(config.LOGGER_NAME)


class URLShortener:
    def __init__(self, input_url: str = None, short_url: str = None):
        self.input_url = input_url
        self.short_url = short_url

    def shorten_url(self) -> str:
        url_pattern = "^https?:\\/\\/(?:www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b(?:[-a-zA-Z0-9()@:%_\\+.~#?&\\/=]*)$"
        valid_url = re.findall(url_pattern, self.input_url)
        if not valid_url:
            _LOGGER.error(f"{self.input_url} is not a valid URL")
        else:
            short_url = Shortener().tinyurl.short(self.input_url)
            _LOGGER.debug(f"Short URL of {self.input_url} is: {short_url}")
        return short_url

    def expand_url(self) -> str:
        try:
            expanded_url = Shortener.tinyurl.expand(self.short_url)
            _LOGGER.debug(f"Expanded URL of ${self.short_url} is : {expanded_url}")
        except Exception:
            _LOGGER.exception(f"Provided URL: {self.short_url} is not valid")

        return expanded_url
