py -m django --version

django-admin startproject project

cd project

py manage.py startapp polls

cat > ./polls/views.py <<EOF
from django.http import HttpResponse

def index(request):
    return HttpResponse("Hello, world. You're at the polls index.")
EOF

cat > ./polls/urls.py <<EOF
from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
]
EOF


cat > ./project/urls.py <<EOF
from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path('polls/', include('polls.urls')),
    path('admin/', admin.site.urls),
]
EOF

py manage.py migrate

cat > ./polls/models.py <<EOF
from django.db import models

class Question(models.Model):
    question_text = models.CharField(max_length=200)
    pub_date = models.DateTimeField('date published')


class Choice(models.Model):
    question = models.ForeignKey(Question, on_delete=models.CASCADE)
    choice_text = models.CharField(max_length=200)
    votes = models.IntegerField(default=0)
EOF

echo update INSTALLED_APPS to include PollsConfig 
# INSTALLED_APPS = ['polls.apps.PollsConfig',

py manage.py makemigrations polls

py manage.py sqlmigrate polls 0001

# BEGIN;
# --
# -- Create model Question
# --
# CREATE TABLE "polls_question" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "question_text" varchar(200) NOT NULL, "pub_date" datetime NOT NULL);
# --
# -- Create model Choice
# --
# CREATE TABLE "polls_choice" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "choice_text" varchar(200) NOT NULL, "votes" integer NOT NULL, "question_id" integer NOT NULL REFERENCES "polls_question" ("id") DEFERRABLE INITIALLY DEFERRED);
# CREATE INDEX "polls_choice_question_id_c5b4b260" ON "polls_choice" ("question_id");
# COMMIT;