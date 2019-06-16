from django.test import SimpleTestCase
from django.urls import reverse,  resolve
from main.views import *
from django.test import TestCase, Client
from main.models import *
import json
from main.forms import * 
from django.utils.encoding import force_text 

class TestUrls(SimpleTestCase):

	def test_list_url_is_reserved_register(self):
		url = reverse('main:register')
		self.assertEqual(url, '/register/')
	
	def test_list_is_resolved_register(self):
		resolver = resolve('/register/')
		self.assertEqual(resolver.view_name, 'main:register')

	def test_list_url_is_reserved_login(self):
		url = reverse('main:login')
		self.assertEqual(url, '/login/')
	
	def test_list_is_resolved_login(self):
		resolver = resolve('/login/')
		self.assertEqual(resolver.view_name, 'main:login')

	def test_list_url_is_reserved_logout(self):
		url = reverse('main:logout')
		self.assertEqual(url, '/logout/')
	
	def test_list_is_resolved_logout(self):
		resolver = resolve('/logout/')
		self.assertEqual(resolver.view_name, 'main:logout')


class TestViews(TestCase):
	
	def setUp(self):
		self.client = Client()
		self.register_url = reverse('main:register')
		self.login_url = reverse('main:login')
		self.logout_url = reverse('main:logout')
		self.home_url = reverse('main:homepage')		
#		self.user = User.objects.create(username="kamil", email="user@tmo.com", password1="Goodpass123", password2="Goodpass123")

	
	def test_home_GET(self):
		response = self.client.get(self.home_url)
		self.assertEquals(response.status_code, 200)
		self.assertTemplateUsed(response, 'main/home.html')

	def test_register_GET(self):
		response = self.client.get(self.register_url)
		self.assertEquals(response.status_code, 200)
		self.assertTemplateUsed(response, 'main/register.html')

	def test_login_GET(self):
		response = self.client.get(self.login_url)
		self.assertEquals(response.status_code, 200)
		self.assertTemplateUsed(response, 'main/login.html')

	def test_logout_GET(self):
		response = self.client.get(self.logout_url)
		self.assertEquals(response.status_code, 302)		
	
	def test_UserForm_valid(self):
		data = {
			'username': 'ttttestclientt',
			'password1': 'test123',
			'password2': 'test123',
		}
		form = UserCreationForm(data)
		self.assertFalse(form.is_valid())

	def test_UserForm_invalid(self):
		data = {
			'username': '',
			'password1': 'test123',
			'password2': 'test123',
		}
		form = UserCreationForm(data)
		self.assertFalse(form.is_valid())