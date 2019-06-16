from django.test import SimpleTestCase
from django.urls import reverse,  resolve
from main.views import *
from django.test import TestCase, Client
from main.models import *
import json
from main.forms import * 
from django.utils.encoding import force_text 

class component_test_for_main_app(TestCase):

	def setUp(self):
		self.client = Client()
		self.register_url = reverse('main:register')
		self.login_url = reverse('main:login')
		self.logout_url = reverse('main:logout')
		self.home_url = reverse('main:homepage')
		self.data = {
			'username': 'ttttestclientt',
			'password1': 'test123',
			'password2': 'test123',
		}		


	def test_user_register_and_view_tutorials(self):
		resolver = resolve('/register/')
		self.assertEqual(resolver.view_name, 'main:register')
		response = self.client.get(self.register_url)
		self.assertEquals(response.status_code, 200)
		self.assertTemplateUsed(response, 'main/register.html')
		form = UserCreationForm(self.data)
		self.assertFalse(form.is_valid())
		response2 = self.client.get(self.home_url)
		self.assertEquals(response2.status_code, 200)
		self.assertTemplateUsed(response2, 'main/home.html')

	def test_user_login_and_view_tutorials(self):
		resolver = resolve('/login/')
		self.assertEqual(resolver.view_name, 'main:login')
		response = self.client.get(self.login_url)
		self.assertEquals(response.status_code, 200)
		self.assertTemplateUsed(response, 'main/login.html')
		form = UserCreationForm(self.data)
		self.assertFalse(form.is_valid())
		response2 = self.client.get(self.home_url)
		self.assertEquals(response2.status_code, 200)
		self.assertTemplateUsed(response2, 'main/home.html')