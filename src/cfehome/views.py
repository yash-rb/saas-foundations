from django.http import HttpResponse
from django.shortcuts import render
from visits.models import PageVisit


def home_page_view(request, *args, **kwargs):
    qs = PageVisit.objects.all()
    page_qs = PageVisit.objects.filter(path=request.path)
    page_title = "Homepage"
    my_context = {
        "page_title": page_title,
        "page_visit_count":page_qs.count(),
        "total_visit_count": qs.count(),
    }
    path = request.path
    PageVisit.objects.create(path=request.path)
    
    html_template = "home.html"
    return render(request, html_template, my_context)
def About_view(request, *args, **kwargs):
    qs = PageVisit.objects.all()
    page_qs = PageVisit.objects.filter(path=request.path)
    page_title = "About"
    my_context = {
        "page_title": page_title,
        "page_visit_count":page_qs.count(),
        "total_visit_count": qs.count(),
    }
    path = request.path
    PageVisit.objects.create(path=request.path)
    
    html_template = "home.html"
    return render(request, html_template, my_context)