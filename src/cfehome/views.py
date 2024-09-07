from django.http import HttpResponse
from django.shortcuts import render


def home_page_view(request, *args, **kwargs):
    page_title = "Homepage"
    my_context = {
        "page_title": page_title
    }
    
    html_template = "home.html"
    return render(request, html_template, my_context)