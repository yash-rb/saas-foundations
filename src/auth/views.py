from django.shortcuts import render
from django.contrib.auth import authenticate, login

# Create your views here.
def login_view(request):
    username = request.POST["username"]
    password = request.POST["password"]
    
    user = authenticate(request, username=username, 
                        password=password)
    if user is not None:
        login(request, user)
    
    render(request, "auth/login.html",{})

