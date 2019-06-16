from selenium import webdriver
from django.contrib.staticfiles.testing import StaticLiveServerTestCase
from django.urls import reverse
import time
from main.views import *


class MySystemTests(StaticLiveServerTestCase):
    
    def setUp(self):
        self.options = webdriver.ChromeOptions()
        CHROMEDRIVER_PATH = '/var/www/Demo_DevOps/main/tests/chromedriver' 
        self.options.add_argument("start-maximized")
        self.options.add_argument('--disable-gpu')
        self.options.add_argument("disable-infobars")
        self.options.add_argument("--disable-extensions")
        self.options.add_argument("--no-sandbox")
        self.options.add_argument("--disable-dev-shm-usage")
        self.browser = webdriver.Chrome( options=self.options)        
        self.data = {
            'username': 'ttttestclientt',
            'password1': 'test123',
            'password2': 'test123',
        }   

    def tearDown(self):
        self.browser.close()


    def test_user_register_and_check_tutorials(self):
        self.browser.get(self.live_server_url)
        add_url = self.live_server_url + '/'
        self.browser.find_element_by_tag_name('h1').click()
        self.assertEquals(self.browser.current_url, add_url)

    def test_user_login_and_check_tutorials(self):
        self.browser.get(self.live_server_url)
        add_url = self.live_server_url + '/#'
        self.browser.find_element_by_tag_name('a').click()
        self.assertEquals(self.browser.current_url, add_url)

